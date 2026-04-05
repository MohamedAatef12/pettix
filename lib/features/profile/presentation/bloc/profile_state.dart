import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';

enum ProfileStatus { initial, loading, loaded, updating, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserEntity? profile;
  final File? pickedAvatar;
  final int? selectedGenderId;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.pickedAvatar,
    this.selectedGenderId,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? profile,
    File? pickedAvatar,
    int? selectedGenderId,
    String? errorMessage,
    bool clearAvatar = false,
    bool clearGender = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      pickedAvatar: clearAvatar ? null : (pickedAvatar ?? this.pickedAvatar),
      selectedGenderId:
          clearGender ? null : (selectedGenderId ?? this.selectedGenderId),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, profile, pickedAvatar, selectedGenderId, errorMessage];
}
