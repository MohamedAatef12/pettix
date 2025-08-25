import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/core/constants/api_endpoints.dart';

@lazySingleton
class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Map<String, dynamic>> get({
    required String endPoint,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.get(
      '${ApiEndpoints.baseUrl}$endPoint',
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
      '${ApiEndpoints.baseUrl}$endPoint',
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );
    List<dynamic> jsonList = response.data as List<dynamic>;
    return jsonList;
  }

  Future<Map<String, dynamic>> post({
    required String endPoint,
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.post(
      '${ApiEndpoints.baseUrl}$endPoint',
      data: data ?? formData,
      options: Options(
        headers: headers,
        receiveTimeout: const Duration(minutes: 2),
      ),
      queryParameters: queryParameters,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> put({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.put(
      '${ApiEndpoints.baseUrl}$endPoint',
      data: data,
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> delete({
    required String endPoint,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    var response = await _dio.delete(
      '${ApiEndpoints.baseUrl}$endPoint',
      options: Options(headers: headers),
      queryParameters: queryParameters,
    );
    return response.data;
  }
}
