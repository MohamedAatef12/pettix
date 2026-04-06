import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/core/models/response_model.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'constants.dart';

@lazySingleton
class ApiService {
  final Dio _dio;
  final ICacheManager _cache;

  ApiService(this._dio, this._cache) {
    // Add interceptor to attach Bearer token automatically
    _dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _cache.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          final email = await _cache.getSavedEmail();
          final password = await _cache.getSavedPassword();

          if (email != null && password != null) {
            try {
              // Create a temporary Dio to avoid recursion in interceptors
              final refreshDio = Dio();
              final response = await refreshDio.post(
                '${Constants.baseUrl}${Constants.loginEndpoint}',
                data: {
                  'email': email,
                  'password': password,
                },
              );

              final data = response.data;
              if (data != null && data['success'] == true) {
                final newToken = data['result']['token'];
                await _cache.setToken(newToken);

                // Update original request headers and retry
                final options = e.requestOptions;
                options.headers['Authorization'] = 'Bearer $newToken';
                
                final retryResponse = await _dio.fetch(options);
                return handler.resolve(retryResponse);
              }
            } catch (_) {
              // Refresh failed, logout
              _cache.logout();
            }
          } else {
            _cache.logout();
          }
        }
        return handler.next(e);
      },
    ));
  }

  ResponseModel _normalizeResponse(dynamic data) {
    if (data == null || (data is String && data.isEmpty)) {
      return const ResponseModel(success: true, message: '', traceId: '', result: null);
    }

    // If the backend returns a wrapped response object, use the existing factory
    if (data is Map<String, dynamic>) return ResponseModel.fromJson(data);

    // If the backend directly returns a list (e.g. ['reason1', ...]) treat it as success
    if (data is List) {
      return ResponseModel(success: true, message: '', traceId: '', result: data);
    }

    // If Dio returned a raw JSON string, try to decode it
    if (data is String) {
      try {
        final decoded = json.decode(data);
        if (decoded is Map<String, dynamic>) return ResponseModel.fromJson(decoded);
        if (decoded is List) return ResponseModel(success: true, message: '', traceId: '', result: decoded);
      } catch (_) {
        // fallthrough to return a generic failure-shaped ResponseModel
      }
    }

    // Fallback: return a ResponseModel marking failure with the raw body in result
    return ResponseModel(success: false, message: 'Unexpected response format', traceId: '', result: data);
  }

  Future<ResponseModel> get({
    required String endPoint,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.get(
      '${Constants.baseUrl}$endPoint',
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );
    return _normalizeResponse(response.data);
  }

  Future<ResponseModel> getList({
    required String endPoint,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.get(
      '${Constants.baseUrl}$endPoint',
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );

    return _normalizeResponse(response.data);
  }

  Future<ResponseModel> post({
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
    return _normalizeResponse(response.data);
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

  Future<ResponseModel> put({
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
    return _normalizeResponse(response.data);
  }

  Future<ResponseModel> patch({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.patch(
      '${Constants.baseUrl}$endPoint',
      data: data,
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );
    return _normalizeResponse(response.data);
  }

  Future<ResponseModel> delete({
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

    return _normalizeResponse(response.data);
  }
}
