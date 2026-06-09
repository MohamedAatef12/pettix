import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/my_pets/presentation/widgets/pets_section.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_animation_tokens.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_info_tile.dart';

class ProfileReadInfo extends StatelessWidget {
  final UserEntity profile;
  final bool isCurrentUser;
  final int? userId;

  const ProfileReadInfo({
    super.key,
    required this.profile,
    required this.isCurrentUser,
    this.userId,
  });

  String get _displayName => profile.nameEn ?? profile.userName;
  String get _genderLabel {
    if (profile.genderId == 1) return AppText.male;
    if (profile.genderId == 2) return AppText.female;
    return profile.gender ?? '-';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 28.h),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(AppText.personalInfo),
          ProfileInfoTile(
            icon: Icons.person,
            iconColor: AppColors.current.primary,
            label: AppText.fullName,
            value: _displayName,
          ),
          ProfileInfoTile(
            icon: Icons.email,
            iconColor: const Color(0xFF5EA8DF),
            label: AppText.email,
            value: profile.email,
          ),
          ProfileInfoTile(
            icon: Icons.phone,
            iconColor: const Color(0xFF56C590),
            label: AppText.phone,
            value: profile.phone ?? '-',
          ),
          SizedBox(height: 8.h),
          _SectionTitle(AppText.details),
          ProfileInfoTile(
            icon: Icons.cake,
            iconColor: const Color(0xFFE8A838),
            label: AppText.age,
            value: profile.age?.toString() ?? '-',
          ),
          ProfileInfoTile(
            icon: Icons.wc_rounded,
            iconColor: const Color(0xFF3AAFA9),
            label: AppText.gender,
            value: _genderLabel,
          ),
          ProfileInfoTile(
            icon: Icons.location_on,
            iconColor: AppColors.current.red,
            label: AppText.address,
            value: profile.address ?? '-',
          ),
          SizedBox(height: 10.h),
          _SectionTitle(isCurrentUser ? AppText.myPets : AppText.pets),
          PetsSection(isCurrentUser: isCurrentUser, userId: userId),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: AppTextStyles.bold.copyWith(
          color: ProfileAnimationTokens.titleText,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}
