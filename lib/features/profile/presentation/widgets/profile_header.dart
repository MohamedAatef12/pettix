import 'package:pettix/core/widgets/app_profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';

import 'package:pettix/core/widgets/app_icon_system.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity profile;
  final VoidCallback? onEditTap;
  const ProfileHeader({super.key, required this.profile, this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (context.canPop())
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: AppTopBarBackButton(onPressed: () => context.pop()),
            ),
          )
        else
          SizedBox(height: 48.h),

        // Avatar
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.current.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.current.primary.withAlpha(100),
                    width: 1.5.w,
                  ),
                ),
                child: AppProfileImage(
                  imageUrl: profile.avatar,
                  name: profile.nameEn ?? profile.userName,
                  radius: 46.r,
                  heroTag: 'user_avatar_${profile.id}',
                  backgroundColor: AppColors.current.lightGray,
                ),
              ),
            ),
            if (onEditTap != null)
              Positioned(
                bottom: 2.h,
                right: 2.w,
                child: GestureDetector(
                  onTap: onEditTap,
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: AppColors.current.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.current.primary.withAlpha(80),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: AppIcon.raw(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 14.w,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class ProfileNameSection extends StatelessWidget {
  final UserEntity profile;
  const ProfileNameSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h), // Clean minimal spacing
        Text(
          profile.nameEn ?? profile.userName,
          style: AppTextStyles.bold.copyWith(
            color: AppColors.current.text,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          profile.email,
          style: AppTextStyles.smallDescription.copyWith(
            color: AppColors.current.midGray,
            fontSize: 12.sp,
          ),
        ),
        if (profile.phone != null) ...[
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon.raw(
                Icons.phone_outlined,
                size: 12.w,
                color: AppColors.current.midGray,
              ),
              SizedBox(width: 4.w),
              Text(
                profile.phone!,
                style: AppTextStyles.smallDescription.copyWith(
                  color: AppColors.current.midGray,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
