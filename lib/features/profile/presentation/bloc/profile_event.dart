import 'package:equatable/equatable.dart';
import 'package:pettix/features/profile/domain/entities/update_profile_entity.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchProfileEvent extends ProfileEvent {
  final int? userId;
  FetchProfileEvent({this.userId});

  @override
  List<Object?> get props => [userId];
}

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

class DeleteAccountEvent extends ProfileEvent {}

class LoadNotificationSettingsEvent extends ProfileEvent {}

class ToggleNotificationsEvent extends ProfileEvent {
  final bool enabled;
  ToggleNotificationsEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class MuteNotificationsEvent extends ProfileEvent {
  final Duration? duration;
  MuteNotificationsEvent(this.duration);

  @override
  List<Object?> get props => [duration];
}

