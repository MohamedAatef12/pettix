import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/entities/apple_login_entity.dart';
import 'package:pettix/features/auth/domain/entities/google_login_response_entity.dart';
import 'package:pettix/features/auth/domain/repositories/auth_repository.dart';

@injectable
class AppleLoginUseCase extends ParamUseCase<GoogleLoginResponseEntity, AppleLoginEntity> {
  final AuthRepository _repository;
  AppleLoginUseCase(this._repository);

  @override
  Future<Either<Failure, GoogleLoginResponseEntity>> call(AppleLoginEntity param) {
    return _repository.loginWithApple(param);
  }
}
