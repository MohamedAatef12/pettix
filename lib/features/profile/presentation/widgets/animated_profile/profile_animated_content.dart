import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_animation_tokens.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_bottom_actions.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_edit_form.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_header_panel.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_read_info.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_success_overlay.dart';

class ProfileAnimatedContent extends StatelessWidget {
  final UserEntity profile;
  final bool isCurrentUser;
  final int? userId;
  final bool isEditing;
  final bool isUpdating;
  final bool showSuccess;
  final Uint8List? pickedAvatarBytes;
  final VoidCallback onEditTap;
  final VoidCallback onAvatarTap;
  final VoidCallback onCancelEdit;
  final VoidCallback onSubmit;

  const ProfileAnimatedContent({
    super.key,
    required this.profile,
    required this.isCurrentUser,
    this.userId,
    required this.isEditing,
    required this.isUpdating,
    required this.showSuccess,
    this.pickedAvatarBytes,
    required this.onEditTap,
    required this.onAvatarTap,
    required this.onCancelEdit,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final dimColor = Colors.black.withAlpha(125);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: showSuccess ? dimColor : AppColors.current.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor:
            showSuccess ? dimColor : ProfileAnimationTokens.screenBackground,
        systemNavigationBarIconBrightness:
            showSuccess ? Brightness.light : Brightness.dark,
      ),
      child: ColoredBox(
        color: ProfileAnimationTokens.screenBackground,
        child: Stack(
          children: [
            Column(
              children: [
                ProfileHeaderPanel(
                  profile: profile,
                  isEditing: isEditing,
                  canEdit: isCurrentUser,
                  pickedAvatarBytes: pickedAvatarBytes,
                  onEditTap: onEditTap,
                  onAvatarTap: onAvatarTap,
                  onCancelEdit: onCancelEdit,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: ProfileAnimationTokens.medium,
                    switchInCurve: ProfileAnimationTokens.curve,
                    switchOutCurve: ProfileAnimationTokens.curve,
                    layoutBuilder: (currentChild, previousChildren) {
                      return currentChild ?? const SizedBox.shrink();
                    },
                    transitionBuilder: _contentTransition,
                    child:
                        isEditing
                            ? ProfileEditForm(key: const ValueKey('edit'))
                            : ProfileReadInfo(
                              key: const ValueKey('read'),
                              profile: profile,
                              isCurrentUser: isCurrentUser,
                              userId: userId,
                            ),
                  ),
                ),
              ],
            ),
            AnimatedPositioned(
              duration: ProfileAnimationTokens.medium,
              curve: ProfileAnimationTokens.curve,
              left: 0,
              right: 0,
              bottom: isEditing ? 0 : -100,
              child: ProfileBottomActions(
                isUpdating: isUpdating,
                onCancel: onCancelEdit,
                onSubmit: onSubmit,
              ),
            ),
            ProfileSuccessOverlay(
              isVisible: showSuccess,
              overlayColor: dimColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentTransition(Widget child, Animation<double> animation) {
    final offset = Tween<Offset>(
      begin: const Offset(0, 0.025),
      end: Offset.zero,
    ).animate(animation);
    return SlideTransition(position: offset, child: child);
  }
}
