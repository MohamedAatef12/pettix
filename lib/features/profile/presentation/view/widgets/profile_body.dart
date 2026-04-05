import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_state.dart';
import 'package:pettix/features/profile/presentation/view/widgets/profile_header.dart';
import 'package:pettix/features/profile/presentation/view/widgets/profile_info_card.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state.status == ProfileStatus.loading ||
            state.status == ProfileStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == ProfileStatus.error) {
          return Center(child: Text(state.errorMessage ?? AppText.error));
        }
        final profile = state.profile;
        if (profile == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return _ProfileContent(profile: profile);
      },
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final UserEntity profile;
  const _ProfileContent({required this.profile});

  String _genderLabel(int? id) {
    if (id == 1) return AppText.male;
    if (id == 2) return AppText.female;
    return '-';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(profile: profile),
              ProfileNameSection(profile: profile),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(AppText.personalInfo),
                    SizedBox(height: 8.h),
                    ProfileInfoGroup(
                      rows: [
                        ProfileInfoRow(
                          icon: Icons.person_outline_rounded,
                          label: AppText.fullName,
                          value: profile.nameEn ?? profile.userName,
                        ),
                        ProfileInfoRow(
                          icon: Icons.translate_rounded,
                          label: AppText.nameAr,
                          value: profile.nameAr ?? '-',
                          iconColor: const Color(0xFF7A6FD8),
                        ),
                        ProfileInfoRow(
                          icon: Icons.email_outlined,
                          label: AppText.email,
                          value: profile.email,
                          iconColor: const Color(0xFF5EA8DF),
                        ),
                        ProfileInfoRow(
                          icon: Icons.phone_outlined,
                          label: AppText.phone,
                          value: profile.phone ?? '-',
                          iconColor: const Color(0xFF56C590),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _SectionLabel(AppText.details),
                    SizedBox(height: 8.h),
                    ProfileInfoGroup(
                      rows: [
                        ProfileInfoRow(
                          icon: Icons.cake_outlined,
                          label: AppText.age,
                          value: profile.age?.toString() ?? '-',
                          iconColor: const Color(0xFFE8A838),
                        ),
                        ProfileInfoRow(
                          icon: Icons.wc_rounded,
                          label: AppText.gender,
                          value: _genderLabel(profile.genderId),
                          iconColor: const Color(0xFF3AAFA9),
                        ),
                        ProfileInfoRow(
                          icon: Icons.location_on_outlined,
                          label: AppText.address,
                          value: profile.address ?? '-',
                          iconColor: AppColors.current.red,
                        ),
                      ],
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 24.h,
          left: 20.w,
          right: 20.w,
          child: _EditButton(profile: profile),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.smallDescription.copyWith(
        color: AppColors.current.midGray,
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  final UserEntity profile;
  const _EditButton({required this.profile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.editProfile,
        extra: context.read<ProfileBloc>(),
      ),
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: AppColors.current.primary,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.current.primary.withAlpha(80),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_rounded, color: Colors.white, size: 18.w),
            SizedBox(width: 8.w),
            Text(
              AppText.editProfile,
              style: AppTextStyles.bold.copyWith(
                color: Colors.white,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
