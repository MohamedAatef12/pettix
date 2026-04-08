import 'package:equatable/equatable.dart';

class LoginEntity extends Equatable {
  final String email;
  final String password;
  final String? fcmToken;

  const LoginEntity({required this.email, required this.password, this.fcmToken});

  LoginEntity copyWith({
    String? email,
    String? password,
    String? fcmToken,
  }) {
    return LoginEntity(
      email: email ?? this.email,
      password: password ?? this.password,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    fcmToken,
  ];
}
