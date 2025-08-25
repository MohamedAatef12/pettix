import 'package:equatable/equatable.dart';

import 'error_messages.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = ErrorMessages.serverError]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = ErrorMessages.cacheError]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = ErrorMessages.noInternet]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = ErrorMessages.unauthorized]);
}
