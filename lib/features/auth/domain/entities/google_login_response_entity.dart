import 'package:equatable/equatable.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';

class GoogleLoginResponseEntity extends Equatable {
  final bool success;
  final String message;
  final String traceId;

  final bool resultSuccess;
  final String resultMessage;
  final String token;
  final String refreshToken;
  final String role;
  final UserEntity user;

  const GoogleLoginResponseEntity({
    required this.success,
    required this.message,
    required this.traceId,
    required this.resultSuccess,
    required this.resultMessage,
    required this.token,
    required this.refreshToken,
    required this.role,
    required this.user,
  });

  @override
  List<Object?> get props => [
    success,
    message,
    traceId,
    resultSuccess,
    resultMessage,
    token,
    refreshToken,
    role,
    user,
  ];
}