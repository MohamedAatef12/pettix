import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/core/models/response_model.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';

@lazySingleton
class ApiService {
  final Dio _dio;
  final ICacheManager _cache;

  ApiService(this._dio, this._cache);

  ResponseModel _normalizeResponse(dynamic data) {
    if (data == null || (data is String && data.isEmpty)) {
      return const ResponseModel(
        success: true,
        message: '',
        traceId: '',
        result: null,
      );
    }

    if (data is Map<String, dynamic>) return ResponseModel.fromJson(data);

    if (data is List) {
      return ResponseModel(
        success: true,
        message: '',
        traceId: '',
        result: data,
      );
    }

    if (data is String) {
      try {
        final decoded = json.decode(data);
        if (decoded is Map<String, dynamic>) {
          return ResponseModel.fromJson(decoded);
        }
        if (decoded is List) {
          return ResponseModel(
            success: true,
            message: '',
            traceId: '',
            result: decoded,
          );
        }
      } catch (_) {}
    }

    return ResponseModel(
      success: false,
      message: 'Unexpected response format',
      traceId: '',
      result: data,
    );
  }

  Future<ResponseModel> get({
    required String endPoint,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.get(
      endPoint,
      options: Options(
        headers: headers,
        // Remove Content-Type for GET requests as it can cause 400s on some servers
        extra: {'remove_content_type': true},
      ),
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
      endPoint,
      options: Options(headers: headers, extra: {'remove_content_type': true}),
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
      endPoint,
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
      endPoint,
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
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.put(
      endPoint,
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
      endPoint,
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
      endPoint,
      options: Options(
        headers: headers,
        extra: data == null ? {'remove_content_type': true} : null,
      ),
      queryParameters: queryParameters,
      data: data,
    );

    return _normalizeResponse(response.data);
  }
}
