import 'package:equatable/equatable.dart';
import '../../data/models/adoption_form_request_model.dart';
import '../../domain/entities/adoption_options_entity.dart';

enum AdoptionStatus {
  initial,
  loading,
  loaded,
  error,
  submitting,
  success,
  submitError,
}

class AdoptionState extends Equatable {
  final AdoptionStatus status;
  final AdoptionOptionsEntity? options;
  final String? errorMessage;
  final AdoptionFormRequestModel? formData;
  final int currentStep;

  // Form Fields
  final String fullName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final int? selectedLivingSituationId;
  final int? selectedResidenceTypeId;
  final bool? hasOwnedPetBefore;
  final String? petType;
  final bool agreed;
  final bool termsAccepted;

  const AdoptionState({
    this.status = AdoptionStatus.initial,
    this.options,
    this.errorMessage,
    this.formData,
    this.currentStep = 0,
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.dateOfBirth = '',
    this.selectedLivingSituationId,
    this.selectedResidenceTypeId,
    this.hasOwnedPetBefore,
    this.petType,
    this.agreed = false,
    this.termsAccepted = false,
  });

  AdoptionState copyWith({
    AdoptionStatus? status,
    AdoptionOptionsEntity? options,
    String? errorMessage,
    AdoptionFormRequestModel? formData,
    int? currentStep,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? dateOfBirth,
    int? selectedLivingSituationId,
    int? selectedResidenceTypeId,
    bool? hasOwnedPetBefore,
    String? petType,
    bool? agreed,
    bool? termsAccepted,
  }) {
    return AdoptionState(
      status: status ?? this.status,
      options: options ?? this.options,
      errorMessage: errorMessage,
      formData: formData ?? this.formData,
      currentStep: currentStep ?? this.currentStep,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      selectedLivingSituationId:
          selectedLivingSituationId ?? this.selectedLivingSituationId,
      selectedResidenceTypeId:
          selectedResidenceTypeId ?? this.selectedResidenceTypeId,
      hasOwnedPetBefore: hasOwnedPetBefore ?? this.hasOwnedPetBefore,
      petType: petType ?? this.petType,
      agreed: agreed ?? this.agreed,
      termsAccepted: termsAccepted ?? this.termsAccepted,
    );
  }

  @override
  List<Object?> get props => [
    status,
    options,
    errorMessage,
    formData,
    currentStep,
    fullName,
    email,
    phoneNumber,
    dateOfBirth,
    selectedLivingSituationId,
    selectedResidenceTypeId,
    hasOwnedPetBefore,
    petType,
    agreed,
    termsAccepted,
  ];
}
