import 'package:pettix/features/auth/domain/entities/google_login_entity.dart';

class GoogleLoginModel extends GoogleLoginEntity {
  const GoogleLoginModel({required super.idToken});

  factory GoogleLoginModel.fromJson(Map<String, dynamic> json) {
    return GoogleLoginModel(idToken: json['idToken']);
  }
  Map<String, dynamic> toJson() {
    return {'idToken': idToken};
  }
  GoogleLoginModel.fromEntity(GoogleLoginEntity entity)
      : super(idToken: entity.idToken);
}
