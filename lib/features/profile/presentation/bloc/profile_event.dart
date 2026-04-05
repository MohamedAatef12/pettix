import 'package:equatable/equatable.dart';
import 'package:pettix/features/profile/domain/entities/update_profile_entity.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchProfileEvent extends ProfileEvent {}

class InitEditFormEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final UpdateProfileEntity request;

  UpdateProfileEvent(this.request);

  @override
  List<Object?> get props => [request];
}

class PickAvatarEvent extends ProfileEvent {}

class UpdateGenderEvent extends ProfileEvent {
  final int? genderId;
  UpdateGenderEvent(this.genderId);

  @override
  List<Object?> get props => [genderId];
}
