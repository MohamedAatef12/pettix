import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/api_services.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/my_pets/data/models/lookup_model.dart';
import 'package:pettix/features/my_pets/data/models/pet_model.dart';
import 'package:pettix/features/my_pets/data/models/pet_request_model.dart';
import 'package:pettix/features/my_pets/domain/entities/lookup_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

/// Abstract contract for pet remote data operations.
abstract class MyPetsRemoteDataSource {
  Future<Either<Failure, List<PetEntity>>> getUserPets(int userId);
  Future<Either<Failure, List<LookupEntity>>> getPetCategories();
  Future<Either<Failure, List<LookupEntity>>> getPetColors();
  Future<Either<Failure, List<LookupEntity>>> getPetMedicals();
  Future<Either<Failure, void>> addPet(PetRequestModel request);
  Future<Either<Failure, void>> deletePet(int petId);
  Future<Either<Failure, void>> updatePetStatus(int petId, int status);
}

@LazySingleton(as: MyPetsRemoteDataSource)
class MyPetsRemoteDataSourceImpl implements MyPetsRemoteDataSource {
  final ApiService _apiService;

  MyPetsRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, List<PetEntity>>> getUserPets(int userId) async {
    try {
      final response = await _apiService.get(
        endPoint: '${Constants.userPetsEndpoint}/$userId/pets',
      );
      if (response.success == true) {
        final raw = response.result;
        final list = raw is List ? raw : (raw as Map<String, dynamic>?)?['result'] ?? [];
        return Right(
          (list as List)
              .map((e) => PetModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<LookupEntity>>> getPetCategories() =>
      _fetchLookup(Constants.petCategoryEndpoint);

  @override
  Future<Either<Failure, List<LookupEntity>>> getPetColors() =>
      _fetchLookup(Constants.petColorsEndpoint);

  @override
  Future<Either<Failure, List<LookupEntity>>> getPetMedicals() =>
      _fetchLookup(Constants.petMedicalsEndpoint);

  @override
  Future<Either<Failure, void>> addPet(PetRequestModel request) async {
    try {
      final response = await _apiService.post(
        endPoint: Constants.petsEndpoint,
        data: request.toJson(),
      );
      if (response.success == true) return const Right(null);
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deletePet(int petId) async {
    try {
      final response = await _apiService.delete(
        endPoint: '${Constants.petsEndpoint}/$petId',
      );
      if (response.success == true) return const Right(null);
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> updatePetStatus(int petId, int status) async {
    try {
      final response = await _apiService.patch(
        endPoint: '${Constants.petsEndpoint}/$petId/status',
        data: {'status': status},
      );
      if (response.success == true) return const Right(null);
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  /// Shared helper for endpoints that return a plain list of {id, name} objects.
  Future<Either<Failure, List<LookupEntity>>> _fetchLookup(
    String endpoint,
  ) async {
    try {
      final response = await _apiService.get(endPoint: endpoint);
      if (response.success == true) {
        final raw = response.result;
        final list = raw is List ? raw : <dynamic>[];
        return Right(
          list
              .map((e) => LookupModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }
}
