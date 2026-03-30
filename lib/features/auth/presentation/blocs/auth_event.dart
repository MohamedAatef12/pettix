import 'package:pettix/features/auth/domain/entities/login_entity.dart';

abstract class AuthEvent {}

class RegisterStepOneSubmitted extends AuthEvent {
  final String email;
  final String name;
  final String phone;

  RegisterStepOneSubmitted({
    required this.email,
    required this.name,
    required this.phone,
  });
}
class RegisterStepTwoSubmitted extends AuthEvent {
  final String password;
  final String confirmPassword;

  RegisterStepTwoSubmitted({
    required this.password,
    required this.confirmPassword,
  });
}
class RegisterOtpSubmitted extends AuthEvent {
  final String otp;

  RegisterOtpSubmitted(this.otp);
}

class RegisterTogglePasswordVisibility extends AuthEvent {}

class RegisterToggleConfirmPasswordVisibility extends AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final LoginEntity model;
  final bool rememberMe;
  LoginSubmitted({required this.model, required this.rememberMe});
}

class CheckRemembered extends AuthEvent {}

class LoginTogglePasswordVisibility extends AuthEvent {}
class ResetPasswordTogglePasswordVisibility extends AuthEvent {}
class ResetPasswordToggleConfirmPasswordVisibility extends AuthEvent {}

class ToggleRememberMe extends AuthEvent {
  final bool value;
  ToggleRememberMe(this.value);
}

class GoogleLoginSubmitted extends AuthEvent {
  final bool rememberMe;
  GoogleLoginSubmitted({required this.rememberMe});
}

class VerifyOtpEvent extends AuthEvent {
  final String smsCode;
  VerifyOtpEvent(this.smsCode);
}
class ResendOtpEvent extends AuthEvent {
  final String email;
  ResendOtpEvent(this.email);
}
class ForgotPasswordEvent extends AuthEvent {
  final String email;
  ForgotPasswordEvent(this.email);
}
class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;
  ResetPasswordEvent({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.confirmPassword,
  });
}