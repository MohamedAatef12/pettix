import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/my_pets/domain/entities/lookup_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_request_entity.dart';

/// Abstract contract for all pet-related data operations.
abstract class MyPetsRepository {
  /// Retrieves all pets owned by the given [userId].
  Future<Either<Failure, List<PetEntity>>> getUserPets(int userId);

  /// Fetches the three pet option lookup lists (categories, colors, medicals).
  Future<Either<Failure, PetOptionsEntity>> getPetOptions();

  /// Creates a new pet record on the server.
  Future<Either<Failure, void>> addPet(PetRequestEntity request);

  /// Permanently removes the pet identified by [petId].
  Future<Either<Failure, void>> deletePet(int petId);
}
