import 'package:dio/dio.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:talker/talker.dart';
import 'dart:async';
class TokenInterceptor extends Interceptor {
  final Dio dio;
  final Talker talker;

  TokenInterceptor(this.dio, this.talker);

  bool _isRefreshing = false;
  final List<Completer<Response>> _queue = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await DI.find<ICacheManager>().getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
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

    talker.warning('[401] Unauthorized → trying refresh');

    final cache = DI.find<ICacheManager>();
    final refreshToken = await cache.getRefreshToken();

    /// ❌ No refresh token → logout
    if (refreshToken == null || refreshToken.isEmpty) {
      talker.error('No refresh token → logout');
      await cache.logout();
      return handler.next(err);
    }

    /// 🔁 If already refreshing → queue request
    if (_isRefreshing) {
      final completer = Completer<Response>();
      _queue.add(completer);

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
        throw Exception('Refresh failed');
      }

      /// ✅ Retry original request
      final response = await _retry(err.requestOptions, newToken);
      handler.resolve(response);

      /// ✅ Resolve queued requests
      for (final completer in _queue) {
        try {
          final res = await _retry(err.requestOptions, newToken);
          completer.complete(res);
        } catch (e) {
          completer.completeError(e);
        }
      }

      _queue.clear();
    } catch (e) {
      talker.error('Refresh failed → logout');

      await cache.logout();

      for (final completer in _queue) {
        completer.completeError(e);
      }

      _queue.clear();

      handler.reject(err);
    } finally {
      _isRefreshing = false;
    }
  }

  /// 🔄 Refresh Token API
  Future<String?> _refreshToken() async {
    final cache = DI.find<ICacheManager>();

    final refreshToken = await cache.getRefreshToken();
    final accessToken = await cache.getToken();

    final refreshDio = Dio(BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ));

    final response = await refreshDio.post(
      '/api/Security/Authentication/refresh-token',
      data: {
        'refreshToken': refreshToken,
        'accessToken': accessToken,
      },
    );

    final data = response.data;

    final result = data is Map ? (data['result'] ?? data) : null;

    final newToken = result?['token'] ?? result?['accessToken'];
    final newRefreshToken = result?['refreshToken'];

    if (newToken != null) {
      await cache.setToken(newToken);

      if (newRefreshToken != null) {
        await cache.setRefreshToken(newRefreshToken);
      }

      talker.info('Token refreshed successfully');

      return newToken;
    }

    return null;
  }

  /// 🔁 Retry request safely
  Future<Response> _retry(RequestOptions requestOptions, String token) {
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: {
          ...requestOptions.headers,
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}