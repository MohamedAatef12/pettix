import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/my_pets/data/datasources/my_pets_remote_data_source.dart';
import 'package:pettix/features/my_pets/data/models/pet_request_model.dart';
import 'package:pettix/features/my_pets/domain/entities/lookup_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_request_entity.dart';
import 'package:pettix/features/my_pets/domain/repositories/my_pets_repository.dart';

@LazySingleton(as: MyPetsRepository)
class MyPetsRepositoryImpl implements MyPetsRepository {
  final MyPetsRemoteDataSource _remoteDataSource;

  MyPetsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<PetEntity>>> getUserPets(int userId) =>
      _remoteDataSource.getUserPets(userId);

  @override
  Future<Either<Failure, PetOptionsEntity>> getPetOptions() async {
    final categoriesResult = await _remoteDataSource.getPetCategories();
    if (categoriesResult.isLeft()) {
      return categoriesResult.map((_) => const PetOptionsEntity(
            categories: [],
            colors: [],
            medicals: [],
          ));
    }

    final colorsResult = await _remoteDataSource.getPetColors();
    if (colorsResult.isLeft()) {
      return colorsResult.map((_) => const PetOptionsEntity(
            categories: [],
            colors: [],
            medicals: [],
          ));
    }

    final medicalsResult = await _remoteDataSource.getPetMedicals();
    if (medicalsResult.isLeft()) {
      return medicalsResult.map((_) => const PetOptionsEntity(
            categories: [],
            colors: [],
            medicals: [],
          ));
    }

    return Right(
      PetOptionsEntity(
        categories: categoriesResult.getOrElse(() => []),
        colors: colorsResult.getOrElse(() => []),
        medicals: medicalsResult.getOrElse(() => []),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> addPet(PetRequestEntity request) =>
      _remoteDataSource.addPet(PetRequestModel.fromEntity(request));

  @override
  Future<Either<Failure, void>> deletePet(int petId) =>
      _remoteDataSource.deletePet(petId);

  @override
  Future<Either<Failure, void>> updatePetStatus(int petId, int status) =>
      _remoteDataSource.updatePetStatus(petId, status);

  @override
  Future<Either<Failure, void>> updatePet(int petId, PetRequestEntity request) =>
      _remoteDataSource.updatePet(petId, PetRequestModel.fromEntity(request));
}
