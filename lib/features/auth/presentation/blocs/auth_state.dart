import 'package:pettix/features/auth/domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {}

class RegisterFailure extends AuthState {
  final String message;
  RegisterFailure(this.message);
}

class RegisterPasswordVisibilityChanged extends AuthState {}

class RegisterConfirmPasswordVisibilityChanged extends AuthState {}


class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final UserEntity  user;
  LoginSuccess(this.user);
}
class OtpSent extends AuthState {}
class LoginFailure extends AuthState {
  final String error;
  LoginFailure(this.error);
}
class RegisterStepOneSuccess extends AuthState {}
class RegisterStepTwoSuccess extends AuthState {}
class RegisterOtpSuccess extends AuthState {}
class LoginPasswordVisibilityChanged extends AuthState {}

class LoginRememberMeChanged extends AuthState {
  final bool rememberMe;
  LoginRememberMeChanged(this.rememberMe);
}

class GoogleLoginLoading extends AuthState {}

class GoogleLoginSuccess extends AuthState {
  final UserEntity? user;
  GoogleLoginSuccess(this.user);
}

class GoogleLoginFailure extends AuthState {
  final String error;
  GoogleLoginFailure(this.error);
}

class AppleLoginLoading extends AuthState {}

class AppleLoginSuccess extends AuthState {
  final UserEntity? user;
  AppleLoginSuccess(this.user);
}

class AppleLoginFailure extends AuthState {
  final String error;
  AppleLoginFailure(this.error);
}


class AuthLoading extends AuthState {}


class AuthSuccess extends AuthState {
  final UserEntity user;
  AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
class OtpVerificationLoading extends AuthState {}
class OtpVerificationSuccess extends AuthState {}
class OtpVerificationFailure extends AuthState {
  final String message;
  OtpVerificationFailure(this.message);
}
class ResendOtpLoading extends AuthState {}
class ResendOtpSuccess extends AuthState {}
class ResendOtpFailure extends AuthState {
  final String message;
  ResendOtpFailure(this.message);
}
class ForgotPasswordLoading extends AuthState {}
class ForgotPasswordSuccess extends AuthState {}
class ForgotPasswordFailure extends AuthState {
  final String message;
  ForgotPasswordFailure(this.message);
}

