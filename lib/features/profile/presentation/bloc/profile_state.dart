import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';

enum ProfileStatus { initial, loading, loaded, updating, success, error, deleteSuccess }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserEntity? profile;
  final Uint8List? pickedAvatarBytes;
  final String? pickedAvatarFilename;
  final int? selectedGenderId;
  final String? errorMessage;
  final bool notificationsEnabled;
  final DateTime? notificationsMutedUntil;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.pickedAvatarBytes,
    this.pickedAvatarFilename,
    this.selectedGenderId,
    this.errorMessage,
    this.notificationsEnabled = true,
    this.notificationsMutedUntil,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserEntity? profile,
    Uint8List? pickedAvatarBytes,
    String? pickedAvatarFilename,
    int? selectedGenderId,
    String? errorMessage,
    bool? notificationsEnabled,
    DateTime? notificationsMutedUntil,
    bool clearAvatar = false,
    bool clearGender = false,
    bool clearMute = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      pickedAvatarBytes: clearAvatar ? null : (pickedAvatarBytes ?? this.pickedAvatarBytes),
      pickedAvatarFilename: clearAvatar ? null : (pickedAvatarFilename ?? this.pickedAvatarFilename),
      selectedGenderId: clearGender ? null : (selectedGenderId ?? this.selectedGenderId),
      errorMessage: errorMessage,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationsMutedUntil: clearMute ? null : (notificationsMutedUntil ?? this.notificationsMutedUntil),
    );
  }

  @override
  List<Object?> get props => [
        status,
        profile,
        pickedAvatarBytes,
        pickedAvatarFilename,
        selectedGenderId,
        errorMessage,
        notificationsEnabled,
        notificationsMutedUntil,
      ];
}
