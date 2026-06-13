import 'package:equatable/equatable.dart';

/// A single adoption application, shared by both client-forms and owner-forms.
class AdoptionFormEntity extends Equatable {
  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final int livingSituationId;
  final int typeOfResidenceId;
  final String? livingSituation;
  final String? typeOfResidence;
  final bool hasOwnedOrCaredForPetBefore;
  final String? petType;
  final bool agreesToTerms;
  final int? petId;
  final String? petName;

  /// Maps to [AdoptionFormStatus] enum values: 1=pending, 2=approved, 3=rejected, 4=cancelled.
  final int status;
  final int? clientContactId;
  final int? ownerContactId;

  const AdoptionFormEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.dateOfBirth,
    required this.livingSituationId,
    required this.typeOfResidenceId,
    this.livingSituation,
    this.typeOfResidence,
    required this.hasOwnedOrCaredForPetBefore,
    this.petType,
    required this.agreesToTerms,
    this.petId,
    this.petName,
    required this.status,
    this.clientContactId,
    this.ownerContactId,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phoneNumber,
    dateOfBirth,
    livingSituationId,
    typeOfResidenceId,
    livingSituation,
    typeOfResidence,
    hasOwnedOrCaredForPetBefore,
    petType,
    agreesToTerms,
    petId,
    petName,
    status,
    clientContactId,
    ownerContactId,
  ];
}
