import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
@lazySingleton
class TokenInterceptor extends Interceptor {
  final Dio dio;

  TokenInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await DI.find<ICacheManager>().getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // لو حصل 401
    if (err.response?.statusCode == 401) {
      final refreshToken = await DI.find<ICacheManager>().getRefreshToken();

      if (refreshToken != null) {
        try {
          // جدد التوكن
          final response = await dio.post('/auth/refresh', data: {
            'refresh_token': refreshToken,
          });

          final newToken = response.data['access_token'];
          final newRefreshToken = response.data['refresh_token'];

          // خزّن التوكن الجديد
          await DI.find<ICacheManager>().setToken(newToken);
          await DI.find<ICacheManager>().setRefreshToken(newRefreshToken);

          // كرر الريكوست الأصلي مع التوكن الجديد
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';

          final cloneReq = await dio.request(
            opts.path,
            options: Options(
              method: opts.method,
              headers: opts.headers,
            ),
            data: opts.data,
            queryParameters: opts.queryParameters,
          );

          return handler.resolve(cloneReq);
        } catch (e) {
          // لو فشل التجديد
          return handler.reject(err);
        }
      }
    }

    super.onError(err, handler);
  }
}
