import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:pettix/features/my_pets/domain/repositories/my_pets_repository.dart';

/// Returns the list of pets belonging to the given user ID.
@injectable
class GetUserPetsUseCase extends ParamUseCase<List<PetEntity>, int> {
  final MyPetsRepository _repository;

  GetUserPetsUseCase(this._repository);

  @override
  Future<Either<Failure, List<PetEntity>>> call(int userId) =>
      _repository.getUserPets(userId);
}
