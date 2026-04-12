import 'package:equatable/equatable.dart';

class OTPEntity extends Equatable {
  final String email;
  final String otp;


  const OTPEntity({
    required this.email, required this.otp});

  @override
  List<Object?> get props => [
    email,otp
  ];
}
