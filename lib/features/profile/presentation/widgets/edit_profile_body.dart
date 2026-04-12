import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/profile/domain/entities/update_profile_entity.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_event.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_state.dart';
import 'package:pettix/features/profile/presentation/widgets/avatar_picker.dart';
import 'package:pettix/features/profile/presentation/widgets/gender_dropdown.dart';

class EditProfileBody extends StatelessWidget {
  const EditProfileBody({super.key});

  void _submit(BuildContext context, ProfileState state) {
    final bloc = context.read<ProfileBloc>();
    final profile = state.profile;
    if (profile == null) return;

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (prev, curr) => curr.status != prev.status,
      listener: (context, state) {
        if (state.status == ProfileStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppText.profileUpdated),
              backgroundColor: AppColors.current.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
          context.pop();
        }
        if (state.status == ProfileStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? AppText.error),
              backgroundColor: AppColors.current.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<ProfileBloc>();
        final profile = state.profile;
        if (profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final isUpdating = state.status == ProfileStatus.updating;

        return Column(
          children: [
            // ── Top bar ──────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.current.text,
                      size: 20.w,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      AppText.editProfile,
                      style: AppTextStyles.appbar.copyWith(
                        color: AppColors.current.text,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  isUpdating
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.current.primary,
                          ),
                        )
                      : TextButton(
                          onPressed: () => _submit(context, state),
                          child: Text(
                            AppText.save,
                            style: TextStyle(
                              color: AppColors.current.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                ],
              ),
            ),

            // ── Scrollable form ───────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    AvatarPicker(currentAvatarUrl: profile.avatar),
                    SizedBox(height: 32.h),

                    _SectionLabel(AppText.personalInfo),
                    SizedBox(height: 10.h),
                    _FilledField(
                      controller: bloc.nameEnController,
                      label: AppText.fullName,
                      icon: Icons.person_outline_rounded,
                      iconColor: AppColors.current.primary,
                    ),
                    SizedBox(height: 12.h),
                    _FilledField(
                      controller: bloc.nameArController,
                      label: AppText.nameAr,
                      icon: Icons.translate_rounded,
                      iconColor: const Color(0xFF7A6FD8),
                    ),
                    SizedBox(height: 12.h),
                    _FilledField(
                      controller: bloc.phoneController,
                      label: AppText.phone,
                      icon: Icons.phone_outlined,
                      iconColor: const Color(0xFF56C590),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 24.h),

                    _SectionLabel(AppText.details),
                    SizedBox(height: 10.h),
                    _FilledField(
                      controller: bloc.ageController,
                      label: AppText.age,
                      icon: Icons.cake_outlined,
                      iconColor: const Color(0xFFE8A838),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 12.h),
                    const GenderDropdown(),
                    SizedBox(height: 12.h),
                    _FilledField(
                      controller: bloc.addressController,
                      label: AppText.address,
                      icon: Icons.location_on_outlined,
                      iconColor: AppColors.current.red,
                      maxLines: 2,
                    ),
                    SizedBox(height: 32.h),

                    // ── Save button ────────────────────────────────────────
                    GestureDetector(
                      onTap: isUpdating ? null : () => _submit(context, state),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: isUpdating
                              ? AppColors.current.primary.withAlpha(140)
                              : AppColors.current.primary,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: isUpdating
                              ? []
                              : [
                                  BoxShadow(
                                    color: AppColors.current.primary.withAlpha(80),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: isUpdating
                              ? SizedBox(
                                  width: 22.w,
                                  height: 22.w,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  AppText.saveChanges,
                                  style: AppTextStyles.bold.copyWith(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Reusable filled text field ───────────────────────────────────────────────

class _FilledField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final Color iconColor;
  final TextInputType? keyboardType;
  final int maxLines;

  const _FilledField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.iconColor,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(
        color: AppColors.current.text,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.current.midGray, fontSize: 13.sp),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Icon(icon, color: iconColor, size: 20.w),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 52.w),
        filled: true,
        fillColor: AppColors.current.lightBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: AppColors.current.primary, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.smallDescription.copyWith(
          color: AppColors.current.midGray,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
