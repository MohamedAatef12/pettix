import 'package:equatable/equatable.dart';

class GoogleLoginEntity extends Equatable{
  final String idToken;

  const GoogleLoginEntity({required this.idToken});

  @override
  List<Object?> get props => [idToken];
}