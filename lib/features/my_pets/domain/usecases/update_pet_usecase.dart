import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_request_entity.dart';
import 'package:pettix/features/my_pets/domain/repositories/my_pets_repository.dart';

class UpdatePetParams {
  final int petId;
  final PetRequestEntity request;

  UpdatePetParams(this.petId, this.request);
}

/// Updates an existing pet record on the server.
@injectable
class UpdatePetUseCase extends ParamUseCase<void, UpdatePetParams> {
  final MyPetsRepository _repository;

  UpdatePetUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(UpdatePetParams params) =>
      _repository.updatePet(params.petId, params.request);
}
