import 'package:pettix/features/auth/data/models/user_model.dart';
import 'package:pettix/features/auth/domain/entities/login_response_entity.dart';

class LoginResponseModel extends LoginResponseEntity {
  const LoginResponseModel({
    required super.user,
    required super.token,
    required super.message,
    required super.refreshToken,
    required super.success,
    required super.role,
  });

  /// Normal factory for fresh JSON parsing
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: json['contact'] != null
          ? UserModel.fromJson(json['contact'])
          : const UserModel(
        id: 0,
        email: '',
        userName: '',
      ),
      token: json['token'] ?? '',
      message: json['message'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      success: json['success'] ?? true,
      role: json['role'] ?? '',
    );
  }

  /// NEW: merge old data with new response — keeping old values if new ones are missing
  factory LoginResponseModel.merge({
    required LoginResponseModel oldData,
    required Map<String, dynamic> newJson,
  }) {
    final newUserJson = newJson['contact'] ?? {};
    final mergedUser = UserModel.merge(
      oldUser: oldData.user as UserModel,
      newJson: newUserJson,
    );

    return LoginResponseModel(
      user: mergedUser,
      token: newJson['token'] ?? oldData.token,
      message: newJson['message'] ?? oldData.message,
      refreshToken: newJson['refreshToken'] ?? oldData.refreshToken,
      success: newJson['success'] ?? oldData.success,
      role: newJson['role'] ?? oldData.role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact': (user as UserModel).toJson(),
      'token': token,
      'refreshToken': refreshToken,
      'message': message,
      'success': success,
      'role': role,
    };
  }
}
