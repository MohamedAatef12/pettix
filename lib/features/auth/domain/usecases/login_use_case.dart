import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/features/auth/domain/entities/login_entity.dart';
import 'package:pettix/features/auth/domain/entities/login_response_entity.dart';
import 'package:pettix/features/auth/domain/repositories/auth_repository.dart';
import 'package:pettix/data/network/failure.dart';


@injectable
class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, LoginResponseEntity>> call(LoginEntity entity) async {
    return await repository.login(entity);
  }
}
