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
    if (err.response?.statusCode == 401) {
      final refreshToken = await DI.find<ICacheManager>().getRefreshToken();

      if (refreshToken != null) {
        try {
          // استخدم Dio مؤقت بدون Interceptors
          final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));

          // Endpoint الصحيح لتجديد التوكن
          final response = await refreshDio.post(
            '/api/Authentication/refresh-token',
            data: {
              'refreshToken': refreshToken,
            },
          );

          // استخدم المفاتيح الصحيحة من الـ backend
          final newToken = response.data['accessToken'];
          final newRefreshToken = response.data['refreshToken'];

          // خزّن القيم الجديدة
          await DI.find<ICacheManager>().setToken(newToken);
          await DI.find<ICacheManager>().setRefreshToken(newRefreshToken);

          // أعد تنفيذ الريكوست الأصلي
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
          return handler.reject(err);
        }
      }
    }

    super.onError(err, handler);
  }
}

