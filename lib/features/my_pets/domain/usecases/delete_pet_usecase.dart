import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/my_pets/domain/repositories/my_pets_repository.dart';

/// Permanently removes the pet with the given ID.
@injectable
class DeletePetUseCase extends ParamUseCase<void, int> {
  final MyPetsRepository _repository;

  DeletePetUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(int petId) =>
      _repository.deletePet(petId);
}
