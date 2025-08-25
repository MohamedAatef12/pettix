import 'error_messages.dart';

class AppException implements Exception {
  final String message;

  AppException([this.message = ErrorMessages.defaultError]);
}

class ServerException extends AppException {
  ServerException([super.message = ErrorMessages.serverError]);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = ErrorMessages.unauthorized]);
}

class CacheException extends AppException {
  CacheException([super.message = ErrorMessages.cacheError]);
}

class NetworkException extends AppException {
  NetworkException([super.message = ErrorMessages.noInternet]);
}
