import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/my_pets/domain/repositories/my_pets_repository.dart';

/// Updates the adoption status of a pet (private=0, available=1).
@injectable
class UpdatePetStatusUseCase extends ParamUseCase<void, ({int petId, int status})> {
  final MyPetsRepository _repository;

  UpdatePetStatusUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(({int petId, int status}) params) =>
      _repository.updatePetStatus(params.petId, params.status);
}
