import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';

enum ProfileStatus { initial, loading, loaded, updating, success, error }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserEntity? profile;
  final Uint8List? pickedAvatarBytes;
  final String? pickedAvatarFilename;
  final int? selectedGenderId;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.pickedAvatarBytes,
    this.pickedAvatarFilename,
    this.selectedGenderId,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? profile,
    Uint8List? pickedAvatarBytes,
    String? pickedAvatarFilename,
    int? selectedGenderId,
    String? errorMessage,
    bool clearAvatar = false,
    bool clearGender = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      pickedAvatarBytes: clearAvatar ? null : (pickedAvatarBytes ?? this.pickedAvatarBytes),
      pickedAvatarFilename: clearAvatar ? null : (pickedAvatarFilename ?? this.pickedAvatarFilename),
      selectedGenderId: clearGender ? null : (selectedGenderId ?? this.selectedGenderId),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, profile, pickedAvatarBytes, pickedAvatarFilename, selectedGenderId, errorMessage];
}
