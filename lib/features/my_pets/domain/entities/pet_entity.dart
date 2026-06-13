import 'package:equatable/equatable.dart';

/// Represents a single vaccination record for a pet.
class VaccinationEntity extends Equatable {
  final String name;
  final DateTime? vaccinationDate;

  const VaccinationEntity({required this.name, this.vaccinationDate});

  @override
  List<Object?> get props => [name, vaccinationDate];
}

/// Full pet entity returned by the API (GET /api/Adoption/Pets or user pets list).
class PetEntity extends Equatable {
  final int id;
  final String code;
  final String name;
  final String? description;
  final String? details;
  final int? age;
  final int? adoptionStatus;
  final String? categoryName;
  final String? genderName;
  final String? colorName;
  final List<String> imageUrls;
  final bool isBlocked;
  final List<VaccinationEntity> vaccinations;

  const PetEntity({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.details,
    this.age,
    this.adoptionStatus,
    this.categoryName,
    this.genderName,
    this.colorName,
    this.imageUrls = const [],
    this.isBlocked = false,
    this.vaccinations = const [],
  });

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        description,
        details,
        age,
        adoptionStatus,
        categoryName,
        genderName,
        colorName,
        imageUrls,
        isBlocked,
        vaccinations,
      ];
}
