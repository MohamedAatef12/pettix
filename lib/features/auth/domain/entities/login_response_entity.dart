import 'package:equatable/equatable.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';

class LoginResponseEntity extends Equatable {
  final UserEntity user;
  final String token;
  final String message;

  const LoginResponseEntity({
    required this.user,
    required this.token,
    required this.message,
  });

  @override
  List<Object?> get props => [user, token, message];
}
