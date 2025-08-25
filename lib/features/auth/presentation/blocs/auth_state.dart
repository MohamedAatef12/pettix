import 'package:pettix/features/auth/data/models/register/register_model.dart';
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
  final UserEntity user;
  GoogleLoginSuccess(this.user);
}

class GoogleLoginFailure extends AuthState {
  final String error;
  GoogleLoginFailure(this.error);
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
