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

  ApiService(this._dio, this._cache);

  ResponseModel _normalizeResponse(dynamic data) {
    if (data == null || (data is String && data.isEmpty)) {
      return const ResponseModel(success: true, message: '', traceId: '', result: null);
    }

    if (data is Map<String, dynamic>) return ResponseModel.fromJson(data);

    if (data is List) {
      return ResponseModel(success: true, message: '', traceId: '', result: data);
    }

    if (data is String) {
      try {
        final decoded = json.decode(data);
        if (decoded is Map<String, dynamic>) return ResponseModel.fromJson(decoded);
        if (decoded is List) return ResponseModel(success: true, message: '', traceId: '', result: decoded);
      } catch (_) {}
    }

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
