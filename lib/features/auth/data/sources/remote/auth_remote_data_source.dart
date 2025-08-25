import 'package:dartz/dartz.dart';
import 'package:pettix/features/auth/data/models/login/google_login_model.dart';
import 'package:pettix/features/auth/data/models/login/login_model.dart';
import 'package:pettix/features/auth/data/models/login/login_response_model.dart';
import 'package:pettix/features/auth/data/models/register/register_model.dart';
import 'package:pettix/features/auth/domain/entities/google_login_entity.dart';
import 'package:pettix/features/auth/domain/entities/login_response_entity.dart';
import 'package:pettix/data/network/failure.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, LoginResponseModel>> login(LoginModel model);
  Future<Either<Failure, void>> register(RegisterModel model);
  Future<Either<Failure, LoginResponseModel>> loginWithGoogle(GoogleLoginModel model);
  Future<Either<Failure, bool>> sendOtp(String phoneNumber);
  Future<Either<Failure, bool>> verifyOtp(String phoneNumber, String code);
}
