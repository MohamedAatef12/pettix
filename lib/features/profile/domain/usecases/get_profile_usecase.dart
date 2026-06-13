import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/profile/domain/repositories/profile_repository.dart';

@injectable
class GetProfileUseCase extends ParamUseCase<UserEntity, int> {
  final ProfileRepository _repository;

  GetProfileUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(int id) =>
      _repository.getProfile(id);
}
