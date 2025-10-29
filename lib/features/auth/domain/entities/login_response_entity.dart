import 'package:equatable/equatable.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';

class LoginResponseEntity extends Equatable {
  final UserEntity user;
  final String token;
  final String message;
  final String role;
  final String? refreshToken;
  final bool success;


  const LoginResponseEntity({
    required this.user,
    required this.token,
    required this.message,
    required this.role,
    this.refreshToken,
    this.success = true,
  });

  @override
  List<Object?> get props => [user, token, message,role, refreshToken, success];
}
