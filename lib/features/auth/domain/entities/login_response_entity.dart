import 'package:equatable/equatable.dart';
import 'package:pettix/features/auth/data/models/user_model.dart';

class LoginResponseEntity extends Equatable {
  final String token;
  final String role;
  final String refreshToken;
  final UserModel contact;
  const LoginResponseEntity({
    required this.token,
    required this.role,
    required this.refreshToken,
    required this.contact,
  });

  @override
  List<Object?> get props => [ token,role, refreshToken,contact ];
}
