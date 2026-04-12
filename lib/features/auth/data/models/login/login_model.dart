import 'package:pettix/features/auth/domain/entities/login_entity.dart';
class LoginModel extends LoginEntity {
  const LoginModel({
    required super.email,
    required super.password,
    super.fcmToken
  });
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'fcmToken': fcmToken,
  };

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      fcmToken: json['fcmToken'] ?? '',
    );
  }
  LoginModel.fromEntity(LoginEntity entity)
      : super(email: entity.email, password: entity.password, fcmToken: entity.fcmToken);
  LoginEntity toEntity(LoginModel model) {
    return LoginEntity(
      email: model.email,
      password: model.password,
      fcmToken: model.fcmToken,
    );
  }
}
