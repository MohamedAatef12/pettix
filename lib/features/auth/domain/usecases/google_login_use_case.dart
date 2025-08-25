import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/entities/google_login_entity.dart';
import 'package:pettix/features/auth/domain/entities/login_response_entity.dart';
import 'package:pettix/features/auth/domain/repositories/auth_repository.dart';

@injectable
class GoogleLoginUseCase {
  final AuthRepository repository;
  GoogleLoginUseCase(this.repository);

  Future<Either<Failure, LoginResponseEntity>> call(GoogleLoginEntity entity) async {
    return await repository.loginWithGoogle(entity);
  }
}