import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/pet_toast.dart';
import 'package:pettix/core/widgets/app_dropdown.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_request_entity.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_bloc.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_event.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_state.dart';
import 'package:pettix/features/my_pets/presentation/widgets/pet_gender_selector.dart';
import 'package:pettix/features/my_pets/presentation/widgets/pet_image_picker.dart';
import 'package:pettix/features/my_pets/presentation/widgets/vaccination_builder.dart';

/// Scrollable form body for adding a new pet.
class AddPetForm extends StatelessWidget {
  const AddPetForm({super.key});

  void _submit(BuildContext context) {
    final bloc = context.read<MyPetsBloc>();
    final state = bloc.state;
    final name = bloc.nameController.text.trim();
    if (name.isEmpty) return;

    bloc.add(
      AddPetEvent(
        PetRequestEntity(
          name: name,
          description:
              bloc.descriptionController.text.trim().isEmpty
                  ? null
                  : bloc.descriptionController.text.trim(),
          details:
              bloc.detailsController.text.trim().isEmpty
                  ? null
                  : bloc.detailsController.text.trim(),
          age: int.tryParse(bloc.ageController.text.trim()),
          categoryId: state.selectedCategoryId,
          genderId: state.selectedGenderId,
          colorId: state.selectedColorId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyPetsBloc, MyPetsState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == MyPetsStatus.success) {
          PetToast.showSuccess(context, AppText.petAddedSuccessfully);
          context.pop();
        }
        if (state.status == MyPetsStatus.error) {
          PetToast.showError(context, state.errorMessage ?? AppText.error);
        }
      },
      builder: (context, state) {
        final bloc = context.read<MyPetsBloc>();
        final isSubmitting = state.status == MyPetsStatus.submitting;

        return Column(
          children: [
            _FormTopBar(
              isSubmitting: isSubmitting,
              onSave: () => _submit(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PetImagePickerRow(),
                    SizedBox(height: 20.h),
                    _SectionCard(
                      icon: Icons.info_outline_rounded,
                      iconColor: AppColors.current.primary,
                      label: AppText.basicInfo,
                      children: [
                        _FilledField(
                          controller: bloc.nameController,
                          label: AppText.petName,
                          icon: Icons.pets_rounded,
                          iconColor: AppColors.current.primary,
                        ),
                        SizedBox(height: 10.h),
                        _FilledField(
                          controller: bloc.descriptionController,
                          label: AppText.description,
                          icon: Icons.notes_rounded,
                          iconColor: const Color(0xFF7A6FD8),
                          maxLines: 3,
                        ),
                        SizedBox(height: 10.h),
                        _FilledField(
                          controller: bloc.detailsController,
                          label: AppText.healthPersonalityDetails,
                          icon: Icons.health_and_safety_outlined,
                          iconColor: AppColors.current.teal,
                          maxLines: 3,
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    _SectionCard(
                      icon: Icons.tune_rounded,
                      iconColor: const Color(0xFF5EA8DF),
                      label: AppText.detailsSection,
                      children: [
                        _FilledField(
                          controller: bloc.ageController,
                          label: AppText.ageYears,
                          icon: Icons.cake_outlined,
                          iconColor: const Color(0xFFE8A838),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 10.h),
                        AppDropdown<int>(
                          hint: AppText.category,
                          prefixIcon: Icons.category_outlined,
                          prefixIconColor: const Color(0xFF5EA8DF),
                          items:
                              state.categories
                                  .map(
                                    (e) => AppDropdownItem<int>(
                                      value: e.id,
                                      label: e.name,
                                    ),
                                  )
                                  .toList(),
                          value: state.selectedCategoryId,
                          onChanged:
                              (id) => context.read<MyPetsBloc>().add(
                                SelectCategoryEvent(id),
                              ),
                        ),
                        SizedBox(height: 10.h),
                        PetGenderSelector(
                          selected: state.selectedGenderId,
                          onSelected:
                              (id) => context.read<MyPetsBloc>().add(
                                SelectGenderEvent(id),
                              ),
                        ),
                        SizedBox(height: 10.h),
                        AppDropdown<int>(
                          hint: AppText.color,
                          prefixIcon: Icons.palette_outlined,
                          prefixIconColor: AppColors.current.brown,
                          items:
                              state.colors
                                  .map(
                                    (e) => AppDropdownItem<int>(
                                      value: e.id,
                                      label: e.name,
                                    ),
                                  )
                                  .toList(),
                          value: state.selectedColorId,
                          onChanged:
                              (id) => context.read<MyPetsBloc>().add(
                                SelectColorEvent(id),
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    _SectionCard(
                      icon: Icons.vaccines_rounded,
                      iconColor: AppColors.current.teal,
                      label: AppText.medicalRecords,
                      children: [const VaccinationBuilder()],
                    ),
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

// ── Top app bar ───────────────────────────────────────────────────────────────

class _FormTopBar extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onSave;

  const _FormTopBar({required this.isSubmitting, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 8.h),
          child: Row(
            children: [
              AppTopBarBackButton(onPressed: () => context.pop()),
              Expanded(
                child: Text(
                  AppText.addPet,
                  style: AppTextStyles.appbar.copyWith(
                    color: AppColors.current.text,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _TopBarActionButton(
                label: AppText.add,
                onTap: isSubmitting ? null : onSave,
                isLoading: isSubmitting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section card ──────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final List<Widget> children;

  const _SectionCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
            child: Row(
              children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: AppIcon.raw(icon, color: iconColor, size: 16.w),
                ),
                SizedBox(width: 10.w),
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.current.text,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppColors.current.lightGray),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Save button ───────────────────────────────────────────────────────────────

class _TopBarActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const _TopBarActionButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            height: 40.w,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.current.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child:
                isLoading
                    ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.current.primary,
                      ),
                    )
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcon.raw(
                          Icons.check_rounded,
                          color: AppColors.current.primary,
                          size: 18.w,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          label,
                          style: TextStyle(
                            color: AppColors.current.primary,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }
}

// ── Form field ────────────────────────────────────────────────────────────────

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
        labelStyle: TextStyle(
          color: AppColors.current.midGray,
          fontSize: 13.sp,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: AppIcon.raw(icon, color: iconColor, size: 20.w),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 52.w),
        filled: true,
        fillColor: AppColors.current.lightBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.current.primary, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }
}
