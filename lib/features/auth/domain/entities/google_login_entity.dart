import 'package:equatable/equatable.dart';

class GoogleLoginEntity extends Equatable{
  final String idToken;
  final String? fcmToken;

  const GoogleLoginEntity({required this.idToken, this.fcmToken});

  GoogleLoginEntity copyWith({
    String? idToken,
    String? fcmToken,
  }) {
    return GoogleLoginEntity(
      idToken: idToken ?? this.idToken,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  List<Object?> get props => [idToken, fcmToken];
}