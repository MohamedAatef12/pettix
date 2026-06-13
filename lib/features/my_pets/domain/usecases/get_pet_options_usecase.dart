import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/my_pets/domain/entities/lookup_entity.dart';
import 'package:pettix/features/my_pets/domain/repositories/my_pets_repository.dart';

/// Fetches all pet form option lookups (categories, colors, medicals) in one call.
@injectable
class GetPetOptionsUseCase extends NoParamUseCase<PetOptionsEntity> {
  final MyPetsRepository _repository;

  GetPetOptionsUseCase(this._repository);

  @override
  Future<Either<Failure, PetOptionsEntity>> call() =>
      _repository.getPetOptions();
}
