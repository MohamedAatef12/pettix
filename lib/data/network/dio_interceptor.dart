import 'package:dio/dio.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:talker/talker.dart';
import 'dart:async';
class _QueuedRequest {
  final Completer<Response> completer;
  final RequestOptions options;
  _QueuedRequest({required this.completer, required this.options});
}

class TokenInterceptor extends Interceptor {
  final Dio dio;
  final Talker talker;

  TokenInterceptor(this.dio, this.talker);

  bool _isRefreshing = false;
  final List<_QueuedRequest> _queue = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await DI.find<ICacheManager>().getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Remove Content-Type for GET/DELETE if specified in extra
    if (options.extra['remove_content_type'] == true) {
      options.headers.remove('Content-Type');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.path.contains('refresh-token')) {
      return handler.next(err);
    }

    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    talker.warning('[401] Unauthorized → trying refresh for: ${err.requestOptions.path}');

    final cache = DI.find<ICacheManager>();
    final refreshToken = await cache.getRefreshToken();

    /// ❌ No refresh token → logout
    if (refreshToken == null || refreshToken.isEmpty) {
      talker.error('No refresh token found in cache → logging out');
      await cache.logout();
      return handler.next(err);
    }

    /// 🔁 If already refreshing → queue request
    if (_isRefreshing) {
      talker.info('Refresh already in progress → queueing request: ${err.requestOptions.path}');
      final completer = Completer<Response>();
      _queue.add(_QueuedRequest(completer: completer, options: err.requestOptions));

      try {
        final response = await completer.future;
        return handler.resolve(response);
      } catch (e) {
        return handler.reject(err);
      }
    }

    _isRefreshing = true;

    try {
      final newToken = await _refreshToken();

      if (newToken == null) {
        throw Exception('Refresh failed: New token is null');
      }

      /// ✅ Retry original request (the one that triggered the refresh)
      talker.info('Retrying original request: ${err.requestOptions.path}');
      final response = await _retry(err.requestOptions, newToken);
      handler.resolve(response);

      /// ✅ Resolve queued requests (each with its own options)
      talker.info('Resolving ${_queue.length} queued requests');
      for (final queuedRequest in _queue) {
        try {
          talker.info('Retrying queued request: ${queuedRequest.options.path}');
          final res = await _retry(queuedRequest.options, newToken);
          queuedRequest.completer.complete(res);
        } catch (e) {
          talker.error('Failed to retry queued request: ${queuedRequest.options.path}');
          queuedRequest.completer.completeError(e);
        }
      }

      _queue.clear();
    } catch (e) {
      if (e is DioException) {
        talker.error('Refresh API failed with status ${e.response?.statusCode}: ${e.response?.data}');
      } else {
        talker.error('Unexpected error during token refresh: $e');
      }
      
      talker.error('Refresh process failed → logging out user');
      await cache.logout();

      for (final queuedRequest in _queue) {
        queuedRequest.completer.completeError(e);
      }

      _queue.clear();

      handler.reject(err);
    } finally {
      _isRefreshing = false;
    }
  }

  /// 🔄 Refresh Token API
  Future<String?> _refreshToken() async {
    try {
      final cache = DI.find<ICacheManager>();

      final refreshToken = await cache.getRefreshToken();
      final accessToken = await cache.getToken();

      talker.info('Requesting new token using refresh token...');

      final refreshDio = Dio(BaseOptions(
        baseUrl: Constants.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ));

      final response = await refreshDio.post(
        '/api/Security/Authentication/refresh-token',
        data: {
          'refreshToken': refreshToken,
          'accessToken': accessToken,
        },
      );

      final data = response.data;
      talker.info('Refresh response received: ${response.statusCode}');

      // Some backends return the data wrapped in a ResponseModel, others direct
      final result = data is Map ? (data['result'] ?? data) : null;

      final newToken = result?['token'] ?? result?['accessToken'];
      final newRefreshToken = result?['refreshToken'];

      if (newToken != null) {
        await cache.setToken(newToken);

        if (newRefreshToken != null && newRefreshToken.toString().isNotEmpty) {
          await cache.setRefreshToken(newRefreshToken.toString());
        }

        talker.info('Token refreshed successfully');
        return newToken;
      } else {
        talker.error('Refresh response did not contain a new token. Data: $data');
      }
    } catch (e) {
      if (e is DioException) {
        talker.error('DioException during _refreshToken: ${e.message}');
        if (e.response != null) {
          talker.error('Response data: ${e.response?.data}');
        }
      } else {
        talker.error('General error during _refreshToken: $e');
      }
    }

    return null;
  }

  /// 🔁 Retry request safely
  Future<Response> _retry(RequestOptions requestOptions, String token) {
    // Ensure we use the new token for the retry
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    headers['Authorization'] = 'Bearer $token';

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: headers,
        contentType: requestOptions.contentType,
        extra: requestOptions.extra,
      ),
    );
  }
}