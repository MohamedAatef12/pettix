import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_request_entity.dart';
import 'package:pettix/features/my_pets/domain/repositories/my_pets_repository.dart';

/// Creates a new pet record on the server.
@injectable
class AddPetUseCase extends ParamUseCase<void, PetRequestEntity> {
  final MyPetsRepository _repository;

  AddPetUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(PetRequestEntity request) =>
      _repository.addPet(request);
}
