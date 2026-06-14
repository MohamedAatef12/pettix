import 'dart:async';

import 'package:dio/dio.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/auth_token_refresher.dart';
import 'package:talker/talker.dart';

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

  AuthTokenRefresher get _refresher => DI.find<AuthTokenRefresher>();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await DI.find<ICacheManager>().getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] =
          'Bearer ${_refresher.normalizeToken(token)}';
    }

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

    talker.warning(
      '[401] Unauthorized, trying refresh for: ${err.requestOptions.path}',
    );

    final cache = DI.find<ICacheManager>();
    final refreshToken = await cache.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      talker.error('No refresh token found in cache, logging out');
      cache.logout();
      return handler.next(err);
    }

    if (_isRefreshing) {
      talker.info(
        'Refresh already in progress, queueing request: ${err.requestOptions.path}',
      );
      final completer = Completer<Response>();
      _queue.add(
        _QueuedRequest(completer: completer, options: err.requestOptions),
      );

      try {
        final response = await completer.future;
        return handler.resolve(response);
      } catch (_) {
        return handler.reject(err);
      }
    }

    _isRefreshing = true;

    try {
      final newToken = await _refresher.refresh();
      if (newToken == null) {
        throw Exception('Refresh failed: new token is null');
      }

      talker.info('Retrying original request: ${err.requestOptions.path}');
      final response = await _retry(err.requestOptions, newToken);
      handler.resolve(response);

      talker.info('Resolving ${_queue.length} queued requests');
      for (final queuedRequest in _queue) {
        try {
          final res = await _retry(queuedRequest.options, newToken);
          queuedRequest.completer.complete(res);
        } catch (e) {
          talker.error(
            'Failed to retry queued request: ${queuedRequest.options.path}',
          );
          queuedRequest.completer.completeError(e);
        }
      }

      _queue.clear();
    } catch (e) {
      talker.error('Refresh process failed, logging out user: $e');
      cache.logout();

      for (final queuedRequest in _queue) {
        queuedRequest.completer.completeError(e);
      }
      _queue.clear();

      handler.reject(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response> _retry(RequestOptions requestOptions, String token) {
    final headers = Map<String, dynamic>.from(requestOptions.headers);
    headers['Authorization'] = 'Bearer ${_refresher.normalizeToken(token)}';

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: headers,
        contentType: requestOptions.contentType,
        extra: requestOptions.extra,
        receiveTimeout: requestOptions.receiveTimeout,
        sendTimeout: requestOptions.sendTimeout,
      ),
    );
  }
}
