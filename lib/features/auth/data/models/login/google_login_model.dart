import 'package:pettix/features/auth/domain/entities/google_login_entity.dart';

class GoogleLoginModel extends GoogleLoginEntity {
  const GoogleLoginModel({required super.idToken, super.fcmToken});

  factory GoogleLoginModel.fromJson(Map<String, dynamic> json) {
    return GoogleLoginModel(idToken: json['idToken'], fcmToken: json['fcmToken']);
  }
  Map<String, dynamic> toJson() {
    return {'idToken': idToken, 'fcmToken': fcmToken};
  }
  GoogleLoginModel.fromEntity(GoogleLoginEntity entity)
      : super(idToken: entity.idToken, fcmToken: entity.fcmToken);
}
