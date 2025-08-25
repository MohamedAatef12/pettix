import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/features/auth/domain/entities/register_domain_entity.dart';
import 'package:pettix/features/auth/domain/repositories/auth_repository.dart';
import 'package:pettix/data/network/failure.dart';


@injectable
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, void>> call(RegisterEntity entity) async {
    return await repository.register(entity);
  }
}
