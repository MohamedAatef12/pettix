import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import '../../data/models/adoption_form_request_model.dart';
import '../../domain/usecases/get_adoption_options_usecase.dart';
import '../../domain/usecases/submit_adoption_form_usecase.dart';
import 'adoption_event.dart';
import 'adoption_state.dart';

@injectable
class AdoptionBloc extends Bloc<AdoptionEvent, AdoptionState> {
  final GetAdoptionOptionsUseCase _getAdoptionOptionsUseCase;
  final SubmitAdoptionFormUseCase _submitAdoptionFormUseCase;

  // Controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final dobController = TextEditingController();
  final petTypeController = TextEditingController();
  // pageController moved to UI

  AdoptionBloc(this._getAdoptionOptionsUseCase, this._submitAdoptionFormUseCase)
    : super(const AdoptionState()) {
    on<SetPetId>((event, emit) => emit(state.copyWith(petId: event.petId)));
    on<FetchAdoptionOptions>(_onFetchAdoptionOptions);
    on<UpdateFullName>(
      (event, emit) => emit(state.copyWith(fullName: event.fullName)),
    );
    on<UpdateEmail>((event, emit) => emit(state.copyWith(email: event.email)));
    on<UpdatePhoneNumber>(
      (event, emit) => emit(state.copyWith(phoneNumber: event.phoneNumber)),
    );
    on<UpdateDateOfBirth>(
      (event, emit) => emit(state.copyWith(dateOfBirth: event.dateOfBirth)),
    );
    on<SelectDateOfBirth>((event, emit) {
      final fmt = DateFormat('yyyy-MM-dd').format(event.date);
      dobController.text = fmt;
      emit(state.copyWith(dateOfBirth: fmt));
    });
    on<UpdateLivingSituation>(
      (event, emit) =>
          emit(state.copyWith(selectedLivingSituationId: event.id)),
    );
    on<UpdateResidenceType>(
      (event, emit) => emit(state.copyWith(selectedResidenceTypeId: event.id)),
    );
    on<UpdateHasOwnedPet>(
      (event, emit) => emit(state.copyWith(hasOwnedPetBefore: event.hasOwned)),
    );
    on<UpdatePetType>(
      (event, emit) => emit(state.copyWith(petType: event.petType)),
    );
    on<ToggleAgreement>(
      (event, emit) => emit(state.copyWith(agreed: event.value)),
    );
    on<ToggleTermsAcceptance>(
      (event, emit) => emit(state.copyWith(termsAccepted: event.value)),
    );
    on<JumpToStep>(_onJumpToStep);
    on<NextStep>(_onNextStep);
    on<PreviousStep>(_onPreviousStep);
    on<SubmitAdoptionForm>(_onSubmitAdoptionForm);
    on<ResetForm>(_onResetForm);
  }

  void _onResetForm(ResetForm event, Emitter<AdoptionState> emit) {
    emit(const AdoptionState(currentStep: 0, status: AdoptionStatus.initial));
  }

  // ... (dispose method remains same)

  void _onJumpToStep(JumpToStep event, Emitter<AdoptionState> emit) {
    emit(state.copyWith(currentStep: event.step));
  }

  Future<void> _onFetchAdoptionOptions(
    FetchAdoptionOptions event,
    Emitter<AdoptionState> emit,
  ) async {
    emit(state.copyWith(status: AdoptionStatus.loading));
    final result = await _getAdoptionOptionsUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdoptionStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (options) =>
          emit(state.copyWith(status: AdoptionStatus.loaded, options: options)),
    );
  }

  void _onNextStep(NextStep event, Emitter<AdoptionState> emit) {
    // 0: Intro, 1: Personal, 2: Living, 3: Pet, 4: Agreements, 5: Review
    if (state.currentStep < 5) {
      if (_validateCurrentStep(state)) {
        final nextStep = state.currentStep + 1;
        emit(state.copyWith(currentStep: nextStep));
      } else {
        emit(state.copyWith(errorMessage: "Please fill all required fields"));
        emit(state.copyWith(errorMessage: null));
      }
    }
  }

  void _onPreviousStep(PreviousStep event, Emitter<AdoptionState> emit) {
    if (state.currentStep > 0) {
      final prevStep = state.currentStep - 1;
      emit(state.copyWith(currentStep: prevStep));
    }
  }

  bool _validateCurrentStep(AdoptionState state) {
    switch (state.currentStep) {
      case 0: // Intro
        return true;
      case 1: // Personal
        return state.fullName.isNotEmpty &&
            state.email.isNotEmpty &&
            state.phoneNumber.isNotEmpty &&
            state.dateOfBirth.isNotEmpty;
      case 2: // Living
        return state.selectedLivingSituationId != null &&
            state.selectedResidenceTypeId != null;
      case 3: // Pet
        if (state.hasOwnedPetBefore == null) return false;
        if (state.hasOwnedPetBefore == true &&
            (state.petType == null || state.petType!.isEmpty)) {
          return false;
        }
        return true;
      case 4: // Agreements
        return state.agreed && state.termsAccepted;
      default:
        return true;
    }
  }

  Future<void> _onSubmitAdoptionForm(
    SubmitAdoptionForm event,
    Emitter<AdoptionState> emit,
  ) async {
    if (!state.agreed || !state.termsAccepted) {
      emit(state.copyWith(errorMessage: "Please accept terms and agreements"));
      emit(state.copyWith(errorMessage: null));
      return;
    }

    emit(state.copyWith(status: AdoptionStatus.submitting));

    // Construct request from state
    final request = AdoptionFormRequestModel(
      petId: state.petId ?? 0,
      fullName: state.fullName,
      email: state.email,
      phoneNumber: state.phoneNumber,
      dateOfBirth: state.dateOfBirth,
      livingSituationId: state.selectedLivingSituationId!,
      typeOfResidenceId: state.selectedResidenceTypeId!,
      hasOwnedOrCaredForPetBefore: state.hasOwnedPetBefore!,
      petType: state.petType ?? '',
      hasReadAndUnderstood: state.agreed,
      agreesToTerms: state.termsAccepted,
    );

    final result = await _submitAdoptionFormUseCase(request);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AdoptionStatus.submitError,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: AdoptionStatus.success)),
    );
  }
}
