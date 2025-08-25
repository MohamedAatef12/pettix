import 'package:equatable/equatable.dart';

class OTPEntity extends Equatable {
  final String serviceSid;
  final String authToken;
  final String accountSid;

  const OTPEntity({
    required this.serviceSid,
    required this.authToken,
    required this.accountSid,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    serviceSid,
    authToken,
    accountSid,
  ];
}
