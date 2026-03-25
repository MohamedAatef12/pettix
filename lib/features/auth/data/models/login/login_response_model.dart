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
    final result = json['result'] ?? {};
    return LoginResponseModel(
      user: result['contact'] != null
          ? UserModel.fromJson(result['contact'])
          : const UserModel(
        id: 0,
        email: '',
        userName: '',
      ),
      token: result['token'] ?? '',
      message: result['message'] ?? json['message'] ?? '',
      refreshToken: result['refreshToken'] ?? '',
      success: result['success'] ?? json['success'] ?? true,
      role: result['role'] ?? '',
    );
  }

  /// Merge old data with new response — keeping old values if new ones are missing
  factory LoginResponseModel.merge({
    required LoginResponseModel oldData,
    required Map<String, dynamic> newJson,
  }) {
    final result = newJson['result'] ?? {};
    final newUserJson = result['contact'] ?? {};
    final mergedUser = UserModel.merge(
      oldUser: oldData.user as UserModel,
      newJson: newUserJson,
    );

    return LoginResponseModel(
      user: mergedUser,
      token: result['token'] ?? oldData.token,
      message: result['message'] ?? oldData.message,
      refreshToken: result['refreshToken'] ?? oldData.refreshToken,
      success: result['success'] ?? oldData.success,
      role: result['role'] ?? oldData.role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': {
        'contact': (user as UserModel).toJson(),
        'token': token,
        'refreshToken': refreshToken,
        'message': message,
        'success': success,
        'role': role,
      }
    };
  }
}