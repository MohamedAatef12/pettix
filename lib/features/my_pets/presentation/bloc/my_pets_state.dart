import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:pettix/features/my_pets/domain/entities/lookup_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

enum MyPetsStatus { initial, loading, loaded, submitting, success, error }

class MyPetsState extends Equatable {
  final MyPetsStatus status;
  final List<PetEntity> pets;

  // Lookup data for the add-pet form dropdowns.
  final List<LookupEntity> categories;
  final List<LookupEntity> colors;
  final List<LookupEntity> medicals;

  // Add-pet form transient state.
  final List<Uint8List> pickedImageBytes;
  final List<String> pickedImageFilenames;
  final List<VaccinationEntity> formVaccinations;
  final int? selectedCategoryId;
  final int? selectedColorId;
  final int? selectedGenderId;

  final String? errorMessage;

  const MyPetsState({
    this.status = MyPetsStatus.initial,
    this.pets = const [],
    this.categories = const [],
    this.colors = const [],
    this.medicals = const [],
    this.pickedImageBytes = const [],
    this.pickedImageFilenames = const [],
    this.formVaccinations = const [],
    this.selectedCategoryId,
    this.selectedColorId,
    this.selectedGenderId,
    this.errorMessage,
  });

  MyPetsState copyWith({
    MyPetsStatus? status,
    List<PetEntity>? pets,
    List<LookupEntity>? categories,
    List<LookupEntity>? colors,
    List<LookupEntity>? medicals,
    List<Uint8List>? pickedImageBytes,
    List<String>? pickedImageFilenames,
    List<VaccinationEntity>? formVaccinations,
    int? selectedCategoryId,
    int? selectedColorId,
    int? selectedGenderId,
    String? errorMessage,
    bool clearForm = false,
    bool clearCategory = false,
    bool clearColor = false,
    bool clearGender = false,
  }) {
    return MyPetsState(
      status: status ?? this.status,
      pets: pets ?? this.pets,
      categories: categories ?? this.categories,
      colors: colors ?? this.colors,
      medicals: medicals ?? this.medicals,
      pickedImageBytes: clearForm ? [] : (pickedImageBytes ?? this.pickedImageBytes),
      pickedImageFilenames: clearForm ? [] : (pickedImageFilenames ?? this.pickedImageFilenames),
      formVaccinations: clearForm ? [] : (formVaccinations ?? this.formVaccinations),
      selectedCategoryId: clearForm || clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      selectedColorId: clearForm || clearColor ? null : (selectedColorId ?? this.selectedColorId),
      selectedGenderId: clearForm || clearGender ? null : (selectedGenderId ?? this.selectedGenderId),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        pets,
        categories,
        colors,
        medicals,
        pickedImageBytes,
        pickedImageFilenames,
        formVaccinations,
        selectedCategoryId,
        selectedColorId,
        selectedGenderId,
        errorMessage,
      ];
}
