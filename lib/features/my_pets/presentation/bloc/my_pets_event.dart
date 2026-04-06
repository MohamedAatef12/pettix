import 'package:equatable/equatable.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_request_entity.dart';

abstract class MyPetsEvent extends Equatable {
  const MyPetsEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the current user's pet list from the server.
class FetchUserPetsEvent extends MyPetsEvent {
  const FetchUserPetsEvent();
}

/// Loads category, color, and medical lookup lists from the server.
class FetchPetOptionsEvent extends MyPetsEvent {
  const FetchPetOptionsEvent();
}

/// Submits a new pet to the server, then re-fetches the pet list.
class AddPetEvent extends MyPetsEvent {
  final PetRequestEntity request;
  const AddPetEvent(this.request);

  @override
  List<Object?> get props => [request];
}

/// Permanently removes the given pet, then re-fetches the pet list.
class DeletePetEvent extends MyPetsEvent {
  final int petId;
  const DeletePetEvent(this.petId);

  @override
  List<Object?> get props => [petId];
}

/// Opens the image picker and appends the selection to [pickedImageBytes].
class PickPetImageEvent extends MyPetsEvent {
  const PickPetImageEvent();
}

/// Removes the picked image at [index].
class RemovePetImageEvent extends MyPetsEvent {
  final int index;
  const RemovePetImageEvent(this.index);

  @override
  List<Object?> get props => [index];
}

/// Appends [vaccination] to the form's vaccination list.
class AddVaccinationEvent extends MyPetsEvent {
  final VaccinationEntity vaccination;
  const AddVaccinationEvent(this.vaccination);

  @override
  List<Object?> get props => [vaccination];
}

/// Removes the vaccination at [index] from the form list.
class RemoveVaccinationEvent extends MyPetsEvent {
  final int index;
  const RemoveVaccinationEvent(this.index);

  @override
  List<Object?> get props => [index];
}

/// Updates the selected category for the add-pet form.
class SelectCategoryEvent extends MyPetsEvent {
  final int? categoryId;
  const SelectCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// Updates the selected color for the add-pet form.
class SelectColorEvent extends MyPetsEvent {
  final int? colorId;
  const SelectColorEvent(this.colorId);

  @override
  List<Object?> get props => [colorId];
}

/// Updates the selected gender for the add-pet form.
class SelectGenderEvent extends MyPetsEvent {
  final int? genderId;
  const SelectGenderEvent(this.genderId);

  @override
  List<Object?> get props => [genderId];
}

/// Clears all add-pet form state after a successful submission.
class ResetPetFormEvent extends MyPetsEvent {
  const ResetPetFormEvent();
}

/// Toggles the adoption availability of a pet.
/// [status]: 0 = private, 1 = available.
class UpdatePetStatusEvent extends MyPetsEvent {
  final int petId;
  final int status;

  const UpdatePetStatusEvent({required this.petId, required this.status});

  @override
  List<Object?> get props => [petId, status];
}
