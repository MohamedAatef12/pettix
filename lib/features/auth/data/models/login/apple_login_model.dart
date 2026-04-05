import 'package:pettix/features/auth/domain/entities/apple_login_entity.dart';

class AppleLoginModel extends AppleLoginEntity {
  const AppleLoginModel({required super.idToken});

  Map<String, dynamic> toJson() => {'idToken': idToken};

  AppleLoginModel.fromEntity(AppleLoginEntity entity)
      : super(idToken: entity.idToken);
}
