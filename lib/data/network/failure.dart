import 'package:dio/dio.dart';

class Failure {
  final String message;
  Failure(this.message);
}

class DioFailure extends Failure {
  DioFailure(super.message);

  factory DioFailure.fromDioError(dynamic error) {
    if (error is DioException) {
      // نحاول ناخد رسالة السيرفر لو موجودة
      final responseData = error.response?.data;
      String? serverMessage;

      if (responseData is Map && responseData['message'] != null) {
        serverMessage = responseData['message'].toString();
      } else if (responseData is String) {
        serverMessage = responseData;
      }

      switch (error.type) {
        case DioExceptionType.cancel:
          return DioFailure(serverMessage ?? 'Request was cancelled');
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return DioFailure(serverMessage ?? 'Connection timeout');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode ?? 0;
          return DioFailure(serverMessage ?? 'Received invalid status code: $statusCode');
        case DioExceptionType.badCertificate:
          return DioFailure(serverMessage ?? 'Bad certificate');
        case DioExceptionType.connectionError:
          return DioFailure(serverMessage ?? 'Connection error');
        case DioExceptionType.unknown:
          return DioFailure(serverMessage ?? error.message ?? 'Unexpected error occurred');
      }
    } else {
      return DioFailure('Unexpected error occurred: $error');
    }
  }
}
