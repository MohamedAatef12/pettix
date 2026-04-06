import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_request_entity.dart';
import 'package:pettix/features/my_pets/domain/usecases/add_pet_usecase.dart';
import 'package:pettix/features/my_pets/domain/usecases/delete_pet_usecase.dart';
import 'package:pettix/features/my_pets/domain/usecases/get_pet_options_usecase.dart';
import 'package:pettix/features/my_pets/domain/usecases/get_user_pets_usecase.dart';
import 'package:pettix/features/my_pets/domain/usecases/update_pet_status_usecase.dart';

import 'my_pets_event.dart';
import 'my_pets_state.dart';

@injectable
class MyPetsBloc extends Bloc<MyPetsEvent, MyPetsState> {
  final GetUserPetsUseCase _getUserPets;
  final GetPetOptionsUseCase _getPetOptions;
  final AddPetUseCase _addPet;
  final DeletePetUseCase _deletePet;
  final UpdatePetStatusUseCase _updatePetStatus;
  final ICacheManager _cacheManager;
  final ImagePicker _imagePicker = ImagePicker();

  // Form text controllers — disposed in [close].
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final detailsController = TextEditingController();
  final ageController = TextEditingController();

  MyPetsBloc(
    this._getUserPets,
    this._getPetOptions,
    this._addPet,
    this._deletePet,
    this._updatePetStatus,
    this._cacheManager,
  ) : super(const MyPetsState()) {
    on<FetchUserPetsEvent>(_onFetchUserPets);
    on<FetchPetOptionsEvent>(_onFetchPetOptions);
    on<AddPetEvent>(_onAddPet);
    on<DeletePetEvent>(_onDeletePet);
    on<PickPetImageEvent>(_onPickPetImage);
    on<RemovePetImageEvent>(_onRemovePetImage);
    on<AddVaccinationEvent>(
      (e, emit) => emit(state.copyWith(
        formVaccinations: [...state.formVaccinations, e.vaccination],
      )),
    );
    on<RemoveVaccinationEvent>((e, emit) {
      final updated = List.of(state.formVaccinations)..removeAt(e.index);
      emit(state.copyWith(formVaccinations: updated));
    });
    on<SelectCategoryEvent>(
      (e, emit) => emit(state.copyWith(selectedCategoryId: e.categoryId)),
    );
    on<SelectColorEvent>(
      (e, emit) => emit(state.copyWith(selectedColorId: e.colorId)),
    );
    on<SelectGenderEvent>(
      (e, emit) => emit(state.copyWith(selectedGenderId: e.genderId)),
    );
    on<ResetPetFormEvent>(_onResetForm);
    on<UpdatePetStatusEvent>(_onUpdatePetStatus);
  }

  Future<void> _onFetchUserPets(
    FetchUserPetsEvent event,
    Emitter<MyPetsState> emit,
  ) async {
    final userId = _cacheManager.getUserData()?.id;
    if (userId == null) {
      emit(state.copyWith(
        status: MyPetsStatus.error,
        errorMessage: 'User not found in cache',
      ));
      return;
    }
    emit(state.copyWith(status: MyPetsStatus.loading));
    final result = await _getUserPets(userId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: MyPetsStatus.error,
        errorMessage: failure.message,
      )),
      (pets) => emit(state.copyWith(status: MyPetsStatus.loaded, pets: pets)),
    );
  }

  Future<void> _onFetchPetOptions(
    FetchPetOptionsEvent event,
    Emitter<MyPetsState> emit,
  ) async {
    final result = await _getPetOptions();
    result.fold(
      (failure) => emit(state.copyWith(
        status: MyPetsStatus.error,
        errorMessage: failure.message,
      )),
      (options) => emit(state.copyWith(
        categories: options.categories,
        colors: options.colors,
        medicals: options.medicals,
      )),
    );
  }

  Future<void> _onAddPet(
    AddPetEvent event,
    Emitter<MyPetsState> emit,
  ) async {
    emit(state.copyWith(status: MyPetsStatus.submitting));

    // Attach picked images to the request.
    final images = <PetImageEntity>[];
    for (int i = 0; i < state.pickedImageBytes.length; i++) {
      images.add(PetImageEntity(
        filename: state.pickedImageFilenames.length > i
            ? state.pickedImageFilenames[i]
            : 'pet_image_$i.jpg',
        base64: base64Encode(state.pickedImageBytes[i]),
        state: 1, // newFile
      ));
    }

    final enrichedRequest = PetRequestEntity(
      name: event.request.name,
      description: event.request.description,
      details: event.request.details,
      age: event.request.age,
      categoryId: event.request.categoryId,
      genderId: event.request.genderId,
      colorId: event.request.colorId,
      images: images,
      vaccinations: state.formVaccinations,
    );

    final result = await _addPet(enrichedRequest);

    if (result.isLeft()) {
      result.fold(
        (failure) => emit(state.copyWith(
          status: MyPetsStatus.error,
          errorMessage: failure.message,
        )),
        (_) {},
      );
      return;
    }

    // Re-fetch pets and clear the form on success.
    add(const ResetPetFormEvent());
    add(const FetchUserPetsEvent());
    emit(state.copyWith(status: MyPetsStatus.success));
  }

  Future<void> _onDeletePet(
    DeletePetEvent event,
    Emitter<MyPetsState> emit,
  ) async {
    emit(state.copyWith(status: MyPetsStatus.submitting));
    final result = await _deletePet(event.petId);

    if (result.isLeft()) {
      result.fold(
        (failure) => emit(state.copyWith(
          status: MyPetsStatus.error,
          errorMessage: failure.message,
        )),
        (_) {},
      );
      return;
    }

    add(const FetchUserPetsEvent());
    emit(state.copyWith(status: MyPetsStatus.success));
  }

  Future<void> _onPickPetImage(
    PickPetImageEvent event,
    Emitter<MyPetsState> emit,
  ) async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (picked == null) return;

    // Read bytes immediately to avoid Android temp-cache eviction.
    final Uint8List bytes = await picked.readAsBytes();
    emit(state.copyWith(
      pickedImageBytes: [...state.pickedImageBytes, bytes],
      pickedImageFilenames: [...state.pickedImageFilenames, picked.name],
    ));
  }

  void _onRemovePetImage(
    RemovePetImageEvent event,
    Emitter<MyPetsState> emit,
  ) {
    final bytes = List<Uint8List>.of(state.pickedImageBytes)
      ..removeAt(event.index);
    final names = List<String>.of(state.pickedImageFilenames)
      ..removeAt(event.index);
    emit(state.copyWith(
      pickedImageBytes: bytes,
      pickedImageFilenames: names,
    ));
  }

  Future<void> _onUpdatePetStatus(
    UpdatePetStatusEvent event,
    Emitter<MyPetsState> emit,
  ) async {
    final result = await _updatePetStatus(
      (petId: event.petId, status: event.status),
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: MyPetsStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        // Optimistically update the pet in the local list.
        final updated = state.pets.map((p) {
          if (p.id == event.petId) {
            return PetEntity(
              id: p.id,
              code: p.code,
              name: p.name,
              description: p.description,
              details: p.details,
              age: p.age,
              adoptionStatus: event.status,
              categoryName: p.categoryName,
              genderName: p.genderName,
              colorName: p.colorName,
              imageUrls: p.imageUrls,
              isBlocked: p.isBlocked,
              vaccinations: p.vaccinations,
            );
          }
          return p;
        }).toList();
        emit(state.copyWith(status: MyPetsStatus.loaded, pets: updated));
      },
    );
  }

  void _onResetForm(ResetPetFormEvent event, Emitter<MyPetsState> emit) {
    nameController.clear();
    descriptionController.clear();
    detailsController.clear();
    ageController.clear();
    emit(state.copyWith(clearForm: true));
  }

  @override
  Future<void> close() {
    nameController.dispose();
    descriptionController.dispose();
    detailsController.dispose();
    ageController.dispose();
    return super.close();
  }
}
