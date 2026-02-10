class AdoptionFormRequestModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final int livingSituationId;
  final int typeOfResidenceId;
  final bool hasOwnedOrCaredForPetBefore;
  final String petType;
  final bool hasReadAndUnderstood;
  final bool agreesToTerms;

  AdoptionFormRequestModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.livingSituationId,
    required this.typeOfResidenceId,
    required this.hasOwnedOrCaredForPetBefore,
    required this.petType,
    required this.hasReadAndUnderstood,
    required this.agreesToTerms,
  });

  Map<String, dynamic> toJson() {
    return {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
        'livingSituationId': livingSituationId,
        'typeOfResidenceId': typeOfResidenceId,
        'hasOwnedOrCaredForPetBefore': hasOwnedOrCaredForPetBefore,
        'petType': petType,
        'hasReadAndUnderstood': hasReadAndUnderstood,
        'agreesToTerms': agreesToTerms,
    };
  }
}
