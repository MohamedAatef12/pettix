import 'package:dartz/dartz.dart';
import 'package:pettix/features/auth/data/models/login/google_login_model.dart';
import 'package:pettix/features/auth/data/models/login/google_login_response_model.dart';
import 'package:pettix/features/auth/data/models/login/login_model.dart';
import 'package:pettix/features/auth/data/models/login/login_response_model.dart';
import 'package:pettix/features/auth/data/models/register/register_model.dart';
import 'package:pettix/data/network/failure.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, LoginResponseModel>> login(LoginModel model);
  Future<Either<Failure, void>> register(RegisterModel model);
  Future<Either<Failure, GoogleLoginResponseModel>> loginWithGoogle(GoogleLoginModel model);
  Future<Either<Failure, bool>> verifyOtp(String email, String otp);
  Future<Either<Failure, void>> resendOtp(String email);
  Future<Either<Failure, void>> forgotPassword(String email);
  Future<Either<Failure, void>> resetPassword(String email, String otp, String newPassword, String confirmPassword);
}
