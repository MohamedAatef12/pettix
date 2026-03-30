import 'package:pettix/features/auth/data/models/user_model.dart';
import 'package:pettix/features/auth/domain/entities/login_response_entity.dart';

class LoginResponseModel extends LoginResponseEntity{
  const LoginResponseModel({
    required super.token,
    required super.role,
    required super.refreshToken,
    required super.contact,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] ?? '',
      role: json['role'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      contact: UserModel.fromJson(json['contact'] ?? {}),
    );
  }

  LoginResponseEntity toEntity(LoginResponseModel model) {
    return LoginResponseEntity(
      token: model.token,
      role: model.role,
      refreshToken: model.refreshToken,
      contact: model.contact,
    );
  }
}