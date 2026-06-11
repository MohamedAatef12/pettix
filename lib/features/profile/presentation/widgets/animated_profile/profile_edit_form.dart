import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_event.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_state.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_animation_tokens.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_info_tile.dart';

class ProfileEditForm extends StatelessWidget {
  const ProfileEditForm({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProfileBloc>();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 112.h),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EditSectionTitle(AppText.personalInfo),
          ProfileInfoTile(
            icon: Icons.person,
            iconColor: AppColors.current.primary,
            label: AppText.fullName,
            value: '',
            child: ProfileTileTextField(controller: bloc.nameEnController),
          ),
          ProfileInfoTile(
            icon: Icons.email,
            iconColor: const Color(0xFF5EA8DF),
            label: AppText.email,
            value: bloc.state.profile?.email ?? '',
          ),
          ProfileInfoTile(
            icon: Icons.phone,
            iconColor: const Color(0xFF56C590),
            label: AppText.phone,
            value: '',
            child: ProfileTileTextField(
              controller: bloc.phoneController,
              keyboardType: TextInputType.phone,
            ),
          ),
          SizedBox(height: 8.h),
          _EditSectionTitle(AppText.details),
          ProfileInfoTile(
            icon: Icons.cake,
            iconColor: const Color(0xFFE8A838),
            label: AppText.age,
            value: '',
            child: ProfileTileTextField(
              controller: bloc.ageController,
              keyboardType: TextInputType.number,
            ),
          ),
          const _GenderTile(),
          ProfileInfoTile(
            icon: Icons.location_on,
            iconColor: AppColors.current.red,
            label: AppText.address,
            value: '',
            child: ProfileTileTextField(
              controller: bloc.addressController,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditSectionTitle extends StatelessWidget {
  final String text;

  const _EditSectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: AppTextStyles.bold.copyWith(
          color: ProfileAnimationTokens.titleText,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

class _GenderTile extends StatelessWidget {
  const _GenderTile();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen:
          (previous, current) =>
              previous.selectedGenderId != current.selectedGenderId,
      builder: (context, state) {
        return ProfileInfoTile(
          icon: Icons.wc_rounded,
          iconColor: const Color(0xFF3AAFA9),
          label: AppText.gender,
          value: '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: state.selectedGenderId,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: ProfileAnimationTokens.mutedText,
                size: 18.w,
              ),
              dropdownColor: AppColors.current.white,
              style: AppTextStyles.bold.copyWith(
                color: ProfileAnimationTokens.titleText,
                fontSize: 11.sp,
              ),
              onChanged:
                  (value) =>
                      context.read<ProfileBloc>().add(UpdateGenderEvent(value)),
              items: [
                DropdownMenuItem(value: 1, child: Text(AppText.male)),
                DropdownMenuItem(value: 2, child: Text(AppText.female)),
              ],
            ),
          ),
        );
      },
    );
  }
}
