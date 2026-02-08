import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/features/auth/data/models/login/google_login_model.dart';
import 'package:pettix/features/auth/data/models/login/login_model.dart';
import 'package:pettix/features/auth/data/models/register/register_model.dart';
import 'package:pettix/features/auth/data/sources/remote/auth_remote_data_source.dart';
import 'package:pettix/features/auth/domain/entities/google_login_entity.dart';
import 'package:pettix/features/auth/domain/entities/login_entity.dart';
import 'package:pettix/features/auth/domain/entities/login_response_entity.dart';
import 'package:pettix/features/auth/domain/entities/register_domain_entity.dart';
import 'package:pettix/features/auth/domain/repositories/auth_repository.dart';
import 'package:pettix/data/network/failure.dart';


@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, LoginResponseEntity>> login(LoginEntity model) async {
    final loginModel = LoginModel.fromEntity(model);
    return await remoteDataSource.login(loginModel);
  }

  @override
  Future<Either<Failure, void>> register(RegisterEntity model) async {
    final registerModel = RegisterModel.fromEntity(model);
    return await remoteDataSource.register(registerModel);
  }
  @override
  Future<Either<Failure, LoginResponseEntity>> loginWithGoogle(GoogleLoginEntity model) async {
    final googleLoginModel = GoogleLoginModel.fromEntity(model);
    return await remoteDataSource.loginWithGoogle(googleLoginModel);
  }
  @override
  Future<Either<Failure, bool>> sendOtp(String email) async {
    return await remoteDataSource.sendOtp(email);
  }
  @override
  Future<Either<Failure, bool>> verifyOtp(String email, String code) async {
    return await remoteDataSource.verifyOtp(email, code);
  }
}
