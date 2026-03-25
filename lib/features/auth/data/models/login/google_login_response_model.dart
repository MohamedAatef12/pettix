import 'package:pettix/features/auth/data/models/user_model.dart';
import 'package:pettix/features/auth/domain/entities/google_login_response_entity.dart';

class GoogleLoginResponseModel extends GoogleLoginResponseEntity {
  const GoogleLoginResponseModel({
    required super.success,
    required super.message,
    required super.traceId,
    required super.resultSuccess,
    required super.resultMessage,
    required super.token,
    required super.refreshToken,
    required super.role,
    required super.user,
  });

  factory GoogleLoginResponseModel.fromJson(Map<String, dynamic> json) {
    final result = json['result'] ?? {};

    return GoogleLoginResponseModel(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      traceId: json['traceId'] ?? '',
      resultSuccess: result['success'] ?? true,
      resultMessage: result['message'] ?? '',
      token: result['token'] ?? '',
      refreshToken: result['refreshToken'] ?? '',
      role: result['role'] ?? '',
      user: result['contact'] != null
          ? UserModel.fromJson(result['contact'])
          : const UserModel(
        id: 0,
        email: '',
        userName: '',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'traceId': traceId,
      'result': {
        'success': resultSuccess,
        'message': resultMessage,
        'token': token,
        'refreshToken': refreshToken,
        'role': role,
        'contact': (user as UserModel).toJson(),
      }
    };
  }
}