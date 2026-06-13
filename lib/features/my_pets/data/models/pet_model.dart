import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

/// Data model for a single vaccination record.
class VaccinationModel extends VaccinationEntity {
  const VaccinationModel({required super.name, super.vaccinationDate});

  factory VaccinationModel.fromJson(Map<String, dynamic> json) {
    final dateStr = json['vaccinationDate'] as String?;
    return VaccinationModel(
      name: json['name'] as String? ?? '',
      vaccinationDate: dateStr != null ? DateTime.tryParse(dateStr) : null,
    );
  }
}

/// Data model for a full pet entity returned by the API.
class PetModel extends PetEntity {
  const PetModel({
    required super.id,
    required super.code,
    required super.name,
    super.description,
    super.details,
    super.age,
    super.adoptionStatus,
    super.categoryName,
    super.genderName,
    super.colorName,
    super.imageUrls,
    super.isBlocked,
    super.vaccinations,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    final rawImages = json['imageUrls'];
    final images = rawImages is List
        ? rawImages.map((e) => e.toString()).toList()
        : <String>[];

    final rawVaccinations = json['vaccinations'];
    final vaccinations = rawVaccinations is List
        ? rawVaccinations
            .map((v) => VaccinationModel.fromJson(v as Map<String, dynamic>))
            .toList()
        : <VaccinationModel>[];

    return PetModel(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      details: json['details'] as String?,
      age: json['age'] as int?,
      adoptionStatus: json['adoptionStatus'] as int?,
      categoryName: json['categoryName'] as String?,
      genderName: json['genderName'] as String?,
      colorName: json['colorName'] as String?,
      imageUrls: images,
      isBlocked: json['isBlocked'] as bool? ?? false,
      vaccinations: vaccinations,
    );
  }
}
