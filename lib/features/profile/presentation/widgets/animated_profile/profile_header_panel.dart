import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';
import 'package:pettix/core/widgets/app_profile_image.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_animation_tokens.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_header_top_row.dart';

class ProfileHeaderPanel extends StatelessWidget {
  final UserEntity profile;
  final bool isEditing;
  final bool canEdit;
  final Uint8List? pickedAvatarBytes;
  final VoidCallback onEditTap;
  final VoidCallback onAvatarTap;
  final VoidCallback onCancelEdit;

  const ProfileHeaderPanel({
    super.key,
    required this.profile,
    required this.isEditing,
    required this.canEdit,
    this.pickedAvatarBytes,
    required this.onEditTap,
    required this.onAvatarTap,
    required this.onCancelEdit,
  });

  String get _displayName => profile.nameEn ?? profile.userName;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return AnimatedContainer(
      duration: ProfileAnimationTokens.medium,
      curve: ProfileAnimationTokens.curve,
      height: topInset + (isEditing ? 158.h : 232.h),
      decoration: BoxDecoration(
        color: AppColors.current.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.r)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.r)),
        child: Stack(
          children: [
            Positioned(
              top: topInset + 6.h,
              right: -12.w,
              child: Transform.rotate(
                angle: 0.45,
                child: Icon(
                  Icons.pets,
                  color: Colors.white.withAlpha(22),
                  size: 72.r,
                ),
              ),
            ),
            Positioned(
              bottom: 18.h,
              left: -14.w,
              child: Transform.rotate(
                angle: -0.3,
                child: Icon(
                  Icons.pets,
                  color: Colors.white.withAlpha(16),
                  size: 56.r,
                ),
              ),
            ),
            Positioned(
              top: topInset + 52.h,
              right: 22.w,
              child: Transform.rotate(
                angle: 0.7,
                child: Icon(
                  Icons.pets,
                  color: Colors.white.withAlpha(12),
                  size: 26.r,
                ),
              ),
            ),
            Positioned(
              bottom: 48.h,
              right: 40.w,
              child: Transform.rotate(
                angle: -0.5,
                child: Icon(
                  Icons.pets,
                  color: Colors.white.withAlpha(10),
                  size: 20.r,
                ),
              ),
            ),
            Positioned(
              top: topInset + 18.h,
              left: 30.w,
              child: Transform.rotate(
                angle: 0.25,
                child: Icon(
                  Icons.pets,
                  color: Colors.white.withAlpha(14),
                  size: 32.r,
                ),
              ),
            ),
            Positioned(
              bottom: 80.h,
              left: 60.w,
              child: Transform.rotate(
                angle: -0.8,
                child: Icon(
                  Icons.pets,
                  color: Colors.white.withAlpha(9),
                  size: 18.r,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, topInset + 4.h, 14.w, 0),
              child: Column(
                children: [
                  ProfileHeaderTopRow(
                    isEditing: isEditing,
                    onCancelEdit: onCancelEdit,
                  ),
                  _HeaderAvatar(
                    profile: profile,
                    isEditing: isEditing,
                    canEdit: canEdit,
                    pickedAvatarBytes: pickedAvatarBytes,
                    onEditTap: onEditTap,
                    onAvatarTap: onAvatarTap,
                  ),
                  AnimatedSize(
                    duration: ProfileAnimationTokens.medium,
                    curve: ProfileAnimationTokens.curve,
                    child:
                        isEditing
                            ? const SizedBox.shrink()
                            : _HeaderIdentity(
                              displayName: _displayName,
                              subtitle: profile.email,
                            ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  final UserEntity profile;
  final bool isEditing;
  final bool canEdit;
  final Uint8List? pickedAvatarBytes;
  final VoidCallback onEditTap;
  final VoidCallback onAvatarTap;

  const _HeaderAvatar({
    required this.profile,
    required this.isEditing,
    required this.canEdit,
    this.pickedAvatarBytes,
    required this.onEditTap,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final expandedSize = 104.w;
    final collapsedSize = 76.w;
    final avatarUrl =
        pickedAvatarBytes == null
            ? profile.avatar
            : 'data:image/png;base64,${base64Encode(pickedAvatarBytes!)}';
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: isEditing ? 1 : 0),
      duration: ProfileAnimationTokens.medium,
      curve: ProfileAnimationTokens.curve,
      builder: (context, progress, _) {
        final size = expandedSize + ((collapsedSize - expandedSize) * progress);
        final padding = 4.w + ((3.w - 4.w) * progress);
        final imageRadius = (size - (padding * 2)) / 2;
        final badgeOpacity = canEdit ? 1.0 : 0.0;
        final badgeSize = 34.w + ((32.w - 34.w) * progress);

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: size,
                height: size,
                padding: EdgeInsets.all(padding),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: AppProfileImage(
                  imageUrl: avatarUrl,
                  radius: imageRadius,
                  heroTag: 'user_avatar_${profile.id}',
                ),
              ),
              Positioned(
                right: -2.w,
                bottom: -2.h,
                child: IgnorePointer(
                  ignoring: badgeOpacity == 0,
                  child: Opacity(
                    opacity: badgeOpacity,
                    child: Transform.scale(
                      scale: 0.92 + (0.08 * badgeOpacity),
                      child: GestureDetector(
                        onTap: isEditing ? onAvatarTap : onEditTap,
                        child: Container(
                          width: badgeSize,
                          height: badgeSize,
                          decoration: BoxDecoration(
                            color: AppColors.current.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.w),
                          ),
                          child: AppIcon(
                            token:
                                isEditing
                                    ? AppIconToken.camera
                                    : AppIconToken.edit,
                            color: Colors.white,
                            size: isEditing ? 16.w : 15.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderIdentity extends StatelessWidget {
  final String displayName;
  final String subtitle;

  const _HeaderIdentity({required this.displayName, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 14.h),
        Text(
          displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bold.copyWith(
            color: Colors.white,
            fontSize: 19.sp,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.smallDescription.copyWith(
            color: Colors.white.withAlpha(105),
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}
