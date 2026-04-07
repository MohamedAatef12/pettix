import 'package:dio/dio.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:talker/talker.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;
  final Talker talker;

  TokenInterceptor(this.dio, this.talker);

  static bool _isRefreshing = false;
  static List<({DioException err, ErrorInterceptorHandler handler})> _pendingRequests = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await DI.find<ICacheManager>().getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      talker.warning('[TokenInterceptor] 401 Unauthorized detected. Attempting to refresh token...');
      
      final refreshToken = await DI.find<ICacheManager>().getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        talker.error('[TokenInterceptor] No refresh token found in cache. Forced logout.');
        await DI.find<ICacheManager>().logout();
        return super.onError(err, handler);
      }

      // If already refreshing, add this request to the queue
      if (_isRefreshing) {
        talker.info('[TokenInterceptor] Already refreshing. Queuing request for: ${err.requestOptions.path}');
        _pendingRequests.add((err: err, handler: handler));
        return;
      }

      _isRefreshing = true;

      try {
        talker.info('[TokenInterceptor] Refreshing token via backend...');
        
        final refreshDio = Dio();
        final response = await refreshDio.post(
          '${Constants.baseUrl}/api/Security/Authentication/refresh-token',
          data: {
            'refreshToken': refreshToken,
          },
        );

        final data = response.data;
        talker.info('[TokenInterceptor] Refresh response received: $data');

        // Robust check for token in various formats
        final result = data is Map ? (data['result'] ?? data) : data;
        final newToken = result is Map ? (result['token'] ?? result['accessToken']) : null;
        final newRefreshToken = result is Map ? result['refreshToken'] : null;

        if (newToken != null) {
          talker.info('[TokenInterceptor] Token refreshed successfully.');
          
          // Store new tokens
          await DI.find<ICacheManager>().setToken(newToken);
          if (newRefreshToken != null) {
            await DI.find<ICacheManager>().setRefreshToken(newRefreshToken);
          }

          // 1. Set refreshing to false before retries so they can trigger refresh if needed
          _isRefreshing = false;
          final localPending = List.from(_pendingRequests);
          _pendingRequests.clear();

          // 2. Resolve current request
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';
          
          talker.info('[TokenInterceptor] Retrying original request: ${opts.path}');
          try {
            final cloneReq = await dio.fetch(opts);
            handler.resolve(cloneReq);
          } catch (retryErr) {
            // Already called resolve or it failed, just let it pass
            if (retryErr is DioException) {
               handler.reject(retryErr);
            } else {
               handler.reject(err);
            }
          }

          // 3. Resolve all pending requests in the queue
          if (localPending.isNotEmpty) {
            talker.info('[TokenInterceptor] Resolving ${localPending.length} pending requests.');
            for (final pending in localPending) {
              final pOpts = pending.err.requestOptions;
              pOpts.headers['Authorization'] = 'Bearer $newToken';
              
              try {
                final pClone = await dio.fetch(pOpts);
                pending.handler.resolve(pClone);
              } catch (e) {
                pending.handler.reject(pending.err);
              }
            }
          }
          return;
        } else {
          talker.error('[TokenInterceptor] Refresh response did not contain a valid token.');
          throw Exception('Invalid token in refresh response');
        }
      } catch (e) {
        talker.handle(e, StackTrace.current, '[TokenInterceptor] Token refresh failed');
        
        // Refresh failed (invalid/expired refresh token)
        await DI.find<ICacheManager>().logout();
        
        // Reject all pending requests
        for (final pending in _pendingRequests) {
          pending.handler.reject(pending.err);
        }
        _pendingRequests.clear();
      } finally {
        _isRefreshing = false;
      }
    }

    super.onError(err, handler);
  }
}
