import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'constants.dart';

@lazySingleton
class ApiService {
  final Dio _dio;
  final ICacheManager _cache;

  ApiService(this._dio, this._cache) {
    // Add interceptor to attach Bearer token automatically
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _cache.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.get(
      '${Constants.baseUrl}$endPoint',
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );
    return response.data;
  }

  Future<List<dynamic>> getList({
    required String endPoint,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.get(
      '${Constants.baseUrl}$endPoint',
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );
    return response.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> post({
    required String endPoint,
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.post(
      '${Constants.baseUrl}$endPoint',
      data: data ?? formData,
      options: Options(
        headers: headers,
        receiveTimeout: const Duration(minutes: 2),
      ),
      queryParameters: queryParameters,
    );
    return response.data;
  }

  Future<Response<dynamic>> postWithFullResponse({
    required String endPoint,
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.post(
      '${Constants.baseUrl}$endPoint',
      data: data ?? formData,
      options: Options(
        headers: headers,
        receiveTimeout: const Duration(minutes: 2),
      ),
      queryParameters: queryParameters,
    );
    return response;
  }

  Future<Map<String, dynamic>> put({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.put(
      '${Constants.baseUrl}$endPoint',
      data: data,
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );
    return response.data;
  }

  Future<dynamic> delete({
    required String endPoint,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) async {
    final response = await _dio.delete(
      '${Constants.baseUrl}$endPoint',
      options: Options(headers: headers),
      queryParameters: queryParameters,
      data: data,
    );

    return response.data;
  }
}
