import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_dropdown.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_event.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_state.dart';
import 'package:pettix/features/profile/presentation/widgets/address_map_picker.dart';
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
          _AddressMapTile(controller: bloc.addressController),
        ],
      ),
    );
  }
}

// ── Gender tile — matches ProfileInfoTile style, opens AppDropdown sheet ──────

class _GenderTile extends StatelessWidget {
  const _GenderTile();

  static const _items = [
    AppDropdownItem<int>(
      value: 1,
      label: 'Male',
      icon: Icons.male_rounded,
      iconColor: Color(0xFF5EA8DF),
    ),
    AppDropdownItem<int>(
      value: 2,
      label: 'Female',
      icon: Icons.female_rounded,
      iconColor: Color(0xFFE8A838),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen:
          (prev, curr) => prev.selectedGenderId != curr.selectedGenderId,
      builder: (context, state) {
        final selected =
            _items.where((e) => e.value == state.selectedGenderId).firstOrNull;

        return GestureDetector(
          onTap: () async {
            final result = await AppDropdown.openSheet<int>(
              context,
              hint: AppText.gender,
              items: _items,
              selected: state.selectedGenderId,
            );
            if (result != null && context.mounted) {
              context.read<ProfileBloc>().add(UpdateGenderEvent(result));
            }
          },
          child: ProfileInfoTile(
            icon: Icons.wc_rounded,
            iconColor: const Color(0xFF3AAFA9),
            label: AppText.gender,
            value: '',
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selected?.label ?? '',
                    style: AppTextStyles.bold.copyWith(
                      color: ProfileAnimationTokens.titleText,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: ProfileAnimationTokens.mutedText,
                  size: 16.w,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Section title ─────────────────────────────────────────────────────────────

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

// ── Address tile — read-only, opens map picker on tap ─────────────────────────

class _AddressMapTile extends StatelessWidget {
  final TextEditingController controller;

  const _AddressMapTile({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final picked = await Navigator.of(context).push<String>(
          MaterialPageRoute(
            builder: (_) => AddressMapPickerPage(
              initialAddress: controller.text,
            ),
          ),
        );
        if (!context.mounted) return;
        if (picked != null && picked.isNotEmpty) {
          controller.text = picked;
        }
      },
      child: Container(
        constraints: BoxConstraints(minHeight: 56.h),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: ProfileAnimationTokens.cardBackground,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                color: AppColors.current.red.withAlpha(20),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(
                Icons.location_on,
                color: AppColors.current.red,
                size: 15.w,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppText.address,
                    style: AppTextStyles.smallDescription.copyWith(
                      color: ProfileAnimationTokens.mutedText,
                      fontSize: 8.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller,
                    builder: (_, value, __) => Text(
                      value.text,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bold.copyWith(
                        color: ProfileAnimationTokens.titleText,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Icon(
                Icons.map_outlined,
                color: AppColors.current.primary,
                size: 16.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
