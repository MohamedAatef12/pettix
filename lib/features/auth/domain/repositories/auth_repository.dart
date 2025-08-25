import 'package:dartz/dartz.dart';
import 'package:pettix/features/auth/data/models/login/google_login_model.dart';
import 'package:pettix/features/auth/domain/entities/google_login_entity.dart';
import 'package:pettix/features/auth/domain/entities/login_entity.dart';
import 'package:pettix/features/auth/domain/entities/login_response_entity.dart';
import 'package:pettix/features/auth/domain/entities/register_domain_entity.dart';
import 'package:pettix/data/network/failure.dart';
abstract class AuthRepository {
  Future<Either<Failure, LoginResponseEntity>> login(LoginEntity model);
  Future<Either<Failure, void>> register(RegisterEntity model);
  Future<Either<Failure, LoginResponseEntity>> loginWithGoogle(GoogleLoginEntity model);
  Future<Either<Failure, bool>> sendOtp(String phoneNumber);
  Future<Either<Failure, bool>> verifyOtp(String phoneNumber, String code);
}