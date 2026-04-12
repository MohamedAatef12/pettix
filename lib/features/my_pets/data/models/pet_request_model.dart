import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_request_entity.dart';

/// JSON serialisable image model for pet upload requests.
class PetImageModel extends PetImageEntity {
  const PetImageModel({
    required super.filename,
    required super.base64,
    required super.state,
  });

  factory PetImageModel.fromEntity(PetImageEntity entity) => PetImageModel(
        filename: entity.filename,
        base64: entity.base64,
        state: entity.state,
      );

  Map<String, dynamic> toJson() => {
        'filename': filename,
        'base64': base64,
        'state': state,
      };
}

/// JSON serialisable vaccination model for pet upload requests.
class VaccinationRequestModel extends VaccinationEntity {
  const VaccinationRequestModel({
    required super.name,
    super.vaccinationDate,
  });

  factory VaccinationRequestModel.fromEntity(VaccinationEntity entity) =>
      VaccinationRequestModel(
        name: entity.name,
        vaccinationDate: entity.vaccinationDate,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        // Always send a UTC datetime — Npgsql rejects Kind=Unspecified.
        // Fall back to current UTC time when no date was selected.
        'vaccinationDate':
            (vaccinationDate ?? DateTime.now()).toUtc().toIso8601String(),
      };
}

/// Request model serialised to JSON for POST/PUT /api/Adoption/Pets.
class PetRequestModel extends PetRequestEntity {
  const PetRequestModel({
    required super.name,
    super.description,
    super.details,
    super.age,
    super.categoryId,
    super.genderId,
    super.colorId,
    super.images,
    super.vaccinations,
    super.id,
  });

  factory PetRequestModel.fromEntity(PetRequestEntity entity) => PetRequestModel(
        name: entity.name,
        description: entity.description,
        details: entity.details,
        age: entity.age,
        categoryId: entity.categoryId,
        genderId: entity.genderId,
        colorId: entity.colorId,
        images: entity.images,
        vaccinations: entity.vaccinations,
        id: entity.id,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      if (description != null) 'description': description,
      if (details != null) 'details': details,
      if (age != null) 'age': age,
      if (categoryId != null) 'categoryId': categoryId,
      if (genderId != null) 'genderId': 3,
      if (colorId != null) 'colorId': colorId,
      'images': images
          .map((img) => PetImageModel.fromEntity(img).toJson())
          .toList(),
      'vaccinations': vaccinations
          .map((v) => VaccinationRequestModel.fromEntity(v).toJson())
          .toList(),
    };
    if (id != null) map['id'] = id;
    return map;
  }
}
