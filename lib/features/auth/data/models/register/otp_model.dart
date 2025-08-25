import 'package:pettix/features/auth/domain/entities/otp_entity.dart';

class OTPModel extends OTPEntity{
  const OTPModel({
    required super.serviceSid,
    required super.authToken,
    required super.accountSid,
  });

  factory OTPModel.fromJson(Map<String, dynamic> json) {
    return OTPModel(
      serviceSid: json['serviceSid'],
      authToken: json['authToken'],
      accountSid: json['accountSid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceSid': serviceSid,
      'authToken': authToken,
      'accountSid': accountSid,
    };
  }
  factory OTPModel.fromEntity(OTPEntity entity) {
    return OTPModel(
      serviceSid: entity.serviceSid,
      authToken: entity.authToken,
      accountSid: entity.accountSid,
    );
  }
  Map<String, dynamic> toEntity() {
    return {
      'serviceSid': serviceSid,
      'authToken': authToken,
      'accountSid': accountSid,
    };
  }
}