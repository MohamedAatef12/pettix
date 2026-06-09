import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/utils/auth_toast.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/profile/domain/entities/update_profile_entity.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_event.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_state.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_animated_content.dart';
import 'package:pettix/features/profile/presentation/widgets/profile_shimmer.dart';

class ProfileBody extends StatefulWidget {
  final bool isCurrentUser;
  final int? userId;

  const ProfileBody({super.key, this.isCurrentUser = true, this.userId});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final ValueNotifier<bool> _isEditing = ValueNotifier(false);
  final ValueNotifier<bool> _showSuccess = ValueNotifier(false);
  Timer? _successTimer;

  void _startEditing() {
    context.read<ProfileBloc>().add(InitEditFormEvent());
    _isEditing.value = true;
  }

  void _cancelEditing() {
    _isEditing.value = false;
  }

  void _pickAvatar() {
    context.read<ProfileBloc>().add(PickAvatarEvent());
  }

  void _submit(ProfileState state) {
    if (state.status == ProfileStatus.updating) return;
    final profile = state.profile;
    if (profile == null) return;

    final bloc = context.read<ProfileBloc>();
    final phone = bloc.phoneController.text.trim();
    bloc.add(
      UpdateProfileEvent(
        UpdateProfileEntity(
          id: profile.id,
          nameEn: bloc.nameEnController.text.trim(),
          nameAr: bloc.nameArController.text.trim(),
          phone: phone.isEmpty ? null : phone,
          age: int.tryParse(bloc.ageController.text.trim()),
          address: bloc.addressController.text.trim(),
          genderId: state.selectedGenderId,
          contactTypeId: profile.contactTypeId,
          statusId: profile.statusId,
        ),
      ),
    );
  }

  void _showSavedOverlay() {
    _isEditing.value = false;
    _showSuccess.value = true;
    _successTimer?.cancel();
    _successTimer = Timer(const Duration(milliseconds: 1450), () {
      _showSuccess.value = false;
    });
  }

  @override
  void dispose() {
    _successTimer?.cancel();
    _isEditing.dispose();
    _showSuccess.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (!_isEditing.value) return;
        if (state.status == ProfileStatus.success) {
          _showSavedOverlay();
        } else if (state.status == ProfileStatus.error) {
          AuthToast.showError(context, state.errorMessage ?? AppText.error);
        }
      },
      builder: (context, state) {
        if (state.status == ProfileStatus.loading ||
            state.status == ProfileStatus.initial) {
          return const ProfileShimmer();
        }

        if (state.status == ProfileStatus.error && state.profile == null) {
          return Center(child: Text(state.errorMessage ?? AppText.error));
        }

        final profile = state.profile;
        if (profile == null) return const ProfileShimmer();

        return _ProfileBodyView(
          profile: profile,
          state: state,
          isCurrentUser: widget.isCurrentUser,
          userId: widget.userId,
          isEditing: _isEditing,
          showSuccess: _showSuccess,
          onEditTap: _startEditing,
          onAvatarTap: _pickAvatar,
          onCancelEdit: _cancelEditing,
          onSubmit: () => _submit(state),
        );
      },
    );
  }
}

class _ProfileBodyView extends StatelessWidget {
  final UserEntity profile;
  final ProfileState state;
  final bool isCurrentUser;
  final int? userId;
  final ValueNotifier<bool> isEditing;
  final ValueNotifier<bool> showSuccess;
  final VoidCallback onEditTap;
  final VoidCallback onAvatarTap;
  final VoidCallback onCancelEdit;
  final VoidCallback onSubmit;

  const _ProfileBodyView({
    required this.profile,
    required this.state,
    required this.isCurrentUser,
    required this.userId,
    required this.isEditing,
    required this.showSuccess,
    required this.onEditTap,
    required this.onAvatarTap,
    required this.onCancelEdit,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isEditing,
      builder: (context, editing, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: showSuccess,
          builder: (context, successVisible, _) {
            return ProfileAnimatedContent(
              profile: profile,
              isCurrentUser: isCurrentUser,
              userId: userId,
              isEditing: editing,
              isUpdating: state.status == ProfileStatus.updating,
              showSuccess: successVisible,
              pickedAvatarBytes: state.pickedAvatarBytes,
              onEditTap: onEditTap,
              onAvatarTap: onAvatarTap,
              onCancelEdit: onCancelEdit,
              onSubmit: onSubmit,
            );
          },
        );
      },
    );
  }
}
