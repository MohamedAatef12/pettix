import 'package:pettix/features/auth/domain/entities/login_entity.dart';
class LoginModel extends LoginEntity {
  const LoginModel({
    required super.email,
    required super.password,
  });
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
  LoginModel.fromEntity(LoginEntity entity)
      : super(email: entity.email, password: entity.password);
  LoginEntity toEntity(LoginModel model) {
    return LoginEntity(
      email: model.email,
      password: model.password,
    );
  }
}
