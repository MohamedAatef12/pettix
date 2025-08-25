import 'package:dio/dio.dart';

import 'custom_exceptions.dart';
import 'failure.dart';

class ErrorHandler {
  static Failure handle(Exception exception) {
    if (exception is DioException) {
      return _handleDioError(exception);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else if (exception is UnauthorizedException) {
      return UnauthorizedFailure(exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else {
      return ServerFailure(exception.toString());
    }
  }

  static Failure _handleDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return ServerFailure('Request was cancelled');
      case DioExceptionType.connectionTimeout:
        return NetworkFailure(
          'Connection timeout, please check your internet connection',
        );
      case DioExceptionType.sendTimeout:
        return NetworkFailure('Send timeout, failed to send request');
      case DioExceptionType.receiveTimeout:
        return NetworkFailure('Receive timeout, failed to receive response');
      case DioExceptionType.badResponse:
        final statusCode = dioError.response?.statusCode ?? 0;
        switch (statusCode) {
          case 400:
            return ServerFailure('Bad request [400]');
          case 401:
            return UnauthorizedFailure('Unauthorized [401]');
          case 403:
            return ServerFailure('Forbidden request [403]');
          case 404:
            return ServerFailure('Resource not found [404]');
          case 500:
            return ServerFailure('Internal server error [500]');
          default:
            return ServerFailure('Received invalid status code: $statusCode');
        }
      case DioExceptionType.badCertificate:
        return ServerFailure('Bad SSL certificate');
      case DioExceptionType.connectionError:
        return NetworkFailure('Connection error, please check your network');
      case DioExceptionType.unknown:
        return NetworkFailure(dioError.message ?? 'Unexpected error occurred');
    }
  }
}
