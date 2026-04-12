import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';

/// Data model for an adoption form, deserialised from both
/// client-forms and owner-forms API responses.
class AdoptionFormModel extends AdoptionFormEntity {
  const AdoptionFormModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.phoneNumber,
    super.dateOfBirth,
    required super.livingSituationId,
    required super.typeOfResidenceId,
    super.livingSituation,
    super.typeOfResidence,
    required super.hasOwnedOrCaredForPetBefore,
    super.petType,
    required super.agreesToTerms,
    super.petId,
    super.petName,
    required super.status,
  });

  factory AdoptionFormModel.fromJson(Map<String, dynamic> json) {
    final dobStr = json['dateOfBirth'] as String?;
    DateTime? dob;
    if (dobStr != null) {
      final parsed = DateTime.tryParse(dobStr);
      // Ignore the default .NET zero-date (0001-01-01).
      if (parsed != null && parsed.year > 1) dob = parsed;
    }

    return AdoptionFormModel(
      id: json['id'] as int? ?? 0,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth: dob,
      livingSituationId: json['livingSituationId'] as int? ?? 0,
      typeOfResidenceId: json['typeOfResidenceId'] as int? ?? 0,
      livingSituation: json['livingSituation'] as String?,
      typeOfResidence: json['typeOfResidence'] as String?,
      hasOwnedOrCaredForPetBefore:
          json['hasOwnedOrCaredForPetBefore'] as bool? ?? false,
      petType: json['petType'] as String?,
      agreesToTerms: json['agreesToTerms'] as bool? ?? false,
      petId: json['petId'] as int?,
      petName: json['petName'] as String?,
      status: json['status'] as int? ?? 1,
    );
  }
}
