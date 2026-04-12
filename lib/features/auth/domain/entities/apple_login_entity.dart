import 'package:equatable/equatable.dart';

class AppleLoginEntity extends Equatable {
  final String idToken;

  const AppleLoginEntity({required this.idToken});

  @override
  List<Object?> get props => [idToken];
}
