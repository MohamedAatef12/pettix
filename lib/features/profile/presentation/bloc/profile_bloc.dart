import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/features/auth/data/models/user_model.dart';
import 'package:pettix/features/profile/domain/entities/update_profile_entity.dart';
import 'package:pettix/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:pettix/features/profile/domain/usecases/update_profile_usecase.dart';

import 'profile_event.dart';
import 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final ICacheManager _cacheManager;
  final ImagePicker _imagePicker = ImagePicker();

  // Form controllers — populated by InitEditFormEvent
  final nameEnController = TextEditingController();
  final nameArController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();

  ProfileBloc(
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._cacheManager,
  ) : super(const ProfileState()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<InitEditFormEvent>(_onInitEditForm);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<PickAvatarEvent>(_onPickAvatar);
    on<UpdateGenderEvent>(
      (event, emit) => emit(state.copyWith(selectedGenderId: event.genderId)),
    );
  }

  Future<void> _onFetchProfile(
    FetchProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final userId = _cacheManager.getUserData()?.id;
    if (userId == null) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: 'User not found in cache',
      ));
      return;
    }
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _getProfileUseCase(userId);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (profile) => emit(
        state.copyWith(status: ProfileStatus.loaded, profile: profile),
      ),
    );
  }

  void _onInitEditForm(InitEditFormEvent event, Emitter<ProfileState> emit) {
    final profile = state.profile;
    if (profile == null) return;
    nameEnController.text = profile.nameEn ?? '';
    nameArController.text = profile.nameAr ?? '';
    ageController.text = profile.age?.toString() ?? '';
    addressController.text = profile.address ?? '';
    emit(state.copyWith(selectedGenderId: profile.genderId, clearAvatar: true));
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.updating));

    UpdateProfileEntity request = event.request;

    if (state.pickedAvatar != null) {
      final bytes = await state.pickedAvatar!.readAsBytes();
      final base64Str = base64Encode(bytes);
      final filename = state.pickedAvatar!.path.split('/').last;
      request = UpdateProfileEntity(
        id: event.request.id,
        nameAr: event.request.nameAr,
        nameEn: event.request.nameEn,
        genderId: event.request.genderId,
        contactTypeId: event.request.contactTypeId,
        statusId: event.request.statusId,
        age: event.request.age,
        address: event.request.address,
        avatar: AvatarEntity(
          filename: filename,
          base64: base64Str,
          state: 1,
        ),
      );
    }

    final result = await _updateProfileUseCase(request);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) async {
        final userId = _cacheManager.getUserData()?.id ?? event.request.id;
        final fetchResult = await _getProfileUseCase(userId);
        fetchResult.fold(
          (_) => emit(state.copyWith(status: ProfileStatus.success, clearAvatar: true)),
          (updated) {
            _cacheManager.setUserData(UserModel.fromEntity(updated));
            emit(state.copyWith(
              status: ProfileStatus.success,
              profile: updated,
              clearAvatar: true,
            ));
          },
        );
      },
    );
  }

  Future<void> _onPickAvatar(
    PickAvatarEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) {
      emit(state.copyWith(pickedAvatar: File(picked.path)));
    }
  }

  @override
  Future<void> close() {
    nameEnController.dispose();
    nameArController.dispose();
    ageController.dispose();
    addressController.dispose();
    return super.close();
  }
}
