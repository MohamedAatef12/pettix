import 'package:equatable/equatable.dart';

abstract class AdoptionEvent extends Equatable {
  const AdoptionEvent();

  @override
  List<Object> get props => [];
}

class FetchAdoptionOptions extends AdoptionEvent {
  const FetchAdoptionOptions();
}

class SetPetId extends AdoptionEvent {
  final int petId;
  const SetPetId(this.petId);
  @override
  List<Object> get props => [petId];
}

class UpdateFullName extends AdoptionEvent {
  final String fullName;
  const UpdateFullName(this.fullName);
  @override
  List<Object> get props => [fullName];
}

class UpdateEmail extends AdoptionEvent {
  final String email;
  const UpdateEmail(this.email);
  @override
  List<Object> get props => [email];
}

class UpdatePhoneNumber extends AdoptionEvent {
  final String phoneNumber;
  const UpdatePhoneNumber(this.phoneNumber);
  @override
  List<Object> get props => [phoneNumber];
}

class UpdateDateOfBirth extends AdoptionEvent {
  final String dateOfBirth;
  const UpdateDateOfBirth(this.dateOfBirth);
  @override
  List<Object> get props => [dateOfBirth];
}

class UpdateLivingSituation extends AdoptionEvent {
  final int id;
  const UpdateLivingSituation(this.id);
  @override
  List<Object> get props => [id];
}

class UpdateResidenceType extends AdoptionEvent {
  final int id;
  const UpdateResidenceType(this.id);
  @override
  List<Object> get props => [id];
}

class UpdateHasOwnedPet extends AdoptionEvent {
  final bool hasOwned;
  const UpdateHasOwnedPet(this.hasOwned);
  @override
  List<Object> get props => [hasOwned];
}

class UpdatePetType extends AdoptionEvent {
  final String petType;
  const UpdatePetType(this.petType);
  @override
  List<Object> get props => [petType];
}

class SubmitAdoptionForm extends AdoptionEvent {
  const SubmitAdoptionForm();
}

class ToggleAgreement extends AdoptionEvent {
  final bool value;
  const ToggleAgreement(this.value);
  @override
  List<Object> get props => [value];
}

class ToggleTermsAcceptance extends AdoptionEvent {
  final bool value;
  const ToggleTermsAcceptance(this.value);
  @override
  List<Object> get props => [value];
}

class Submitted extends AdoptionEvent {
  const Submitted();
}

class ResetForm extends AdoptionEvent {
  const ResetForm();
}

class NextStep extends AdoptionEvent {
  const NextStep();
}

class PreviousStep extends AdoptionEvent {
  const PreviousStep();
}

class JumpToStep extends AdoptionEvent {
  final int step;
  const JumpToStep(this.step);
  @override
  List<Object> get props => [step];
}

class SelectDateOfBirth extends AdoptionEvent {
  final DateTime date;
  const SelectDateOfBirth(this.date);
  @override
  List<Object> get props => [date];
}
