import 'package:pettix/features/auth/domain/entities/otp_entity.dart';

class OTPModel extends OTPEntity{
  const OTPModel({

  required super.email, required super.otp});

  factory OTPModel.fromJson(Map<String, dynamic> json) {
    return OTPModel(
        email: json['email'], otp: json['otp']

    );
  }

  Map<String, dynamic> toJson() {
    return {
    'email': email,
    'otp': otp
    };
  }
  factory OTPModel.fromEntity(OTPEntity entity) {
    return OTPModel(
        email: entity.email, otp: entity.otp
    );
  }
  Map<String, dynamic> toEntity() {
    return {
      'email': email,
      'otp': otp
    };
  }
}