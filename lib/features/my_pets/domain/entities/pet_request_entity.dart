import 'package:equatable/equatable.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

/// Represents a single image being uploaded for a pet.
class PetImageEntity extends Equatable {
  final String filename;
  final String base64;

  /// ImageFileState value: 1=newFile, 2=modified, 3=deleted.
  final int state;

  const PetImageEntity({
    required this.filename,
    required this.base64,
    required this.state,
  });

  @override
  List<Object?> get props => [filename, base64, state];
}

/// Request entity used for both POST /api/Adoption/Pets and PUT /api/Adoption/Pets/{id}.
class PetRequestEntity extends Equatable {
  final String name;
  final String? description;
  final String? details;
  final int? age;
  final int? categoryId;
  final int? genderId;
  final int? colorId;
  final List<PetImageEntity> images;
  final List<VaccinationEntity> vaccinations;

  /// Only set when updating an existing pet (PUT).
  final int? id;

  const PetRequestEntity({
    required this.name,
    this.description,
    this.details,
    this.age,
    this.categoryId,
    this.genderId,
    this.colorId,
    this.images = const [],
    this.vaccinations = const [],
    this.id,
  });

  @override
  List<Object?> get props => [
        name,
        description,
        details,
        age,
        categoryId,
        genderId,
        colorId,
        images,
        vaccinations,
        id,
      ];
}
