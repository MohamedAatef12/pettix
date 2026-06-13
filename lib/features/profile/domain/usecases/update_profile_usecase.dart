import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/profile/domain/entities/update_profile_entity.dart';
import 'package:pettix/features/profile/domain/repositories/profile_repository.dart';

@injectable
class UpdateProfileUseCase extends ParamUseCase<void, UpdateProfileEntity> {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(UpdateProfileEntity param) =>
      _repository.updateProfile(param);
}
