import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_request_entity.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_bloc.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_event.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_state.dart';
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

    bloc.add(AddPetEvent(
      PetRequestEntity(
        name: name,
        description: bloc.descriptionController.text.trim().isEmpty
            ? null
            : bloc.descriptionController.text.trim(),
        details: bloc.detailsController.text.trim().isEmpty
            ? null
            : bloc.detailsController.text.trim(),
        age: int.tryParse(bloc.ageController.text.trim()),
        categoryId: state.selectedCategoryId,
        genderId: state.selectedGenderId,
        colorId: state.selectedColorId,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyPetsBloc, MyPetsState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == MyPetsStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Pet added successfully!'),
              backgroundColor: AppColors.current.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
            ),
          );
          context.pop();
        }
        if (state.status == MyPetsStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Something went wrong'),
              backgroundColor: AppColors.current.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
            ),
          );
        }
      },
      builder: (context, state) {
        final bloc = context.read<MyPetsBloc>();
        final isSubmitting = state.status == MyPetsStatus.submitting;

        return Column(
          children: [
            _FormTopBar(isSubmitting: isSubmitting, onSave: () => _submit(context)),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    const PetImagePickerRow(),
                    SizedBox(height: 24.h),

                    _SectionLabel('Basic Info'),
                    SizedBox(height: 10.h),
                    _FilledField(
                      controller: bloc.nameController,
                      label: 'Pet Name',
                      icon: Icons.pets_rounded,
                      iconColor: AppColors.current.primary,
                    ),
                    SizedBox(height: 12.h),
                    _FilledField(
                      controller: bloc.descriptionController,
                      label: 'Description',
                      icon: Icons.notes_rounded,
                      iconColor: const Color(0xFF7A6FD8),
                      maxLines: 3,
                    ),
                    SizedBox(height: 12.h),
                    _FilledField(
                      controller: bloc.detailsController,
                      label: 'Health & Personality Details',
                      icon: Icons.health_and_safety_outlined,
                      iconColor: AppColors.current.teal,
                      maxLines: 3,
                    ),
                    SizedBox(height: 24.h),

                    _SectionLabel('Details'),
                    SizedBox(height: 10.h),
                    _FilledField(
                      controller: bloc.ageController,
                      label: 'Age (years)',
                      icon: Icons.cake_outlined,
                      iconColor: const Color(0xFFE8A838),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 12.h),
                    _LookupDropdown(
                      label: 'Category',
                      icon: Icons.category_outlined,
                      iconColor: const Color(0xFF5EA8DF),
                      items: state.categories,
                      selectedId: state.selectedCategoryId,
                      onChanged: (id) => context
                          .read<MyPetsBloc>()
                          .add(SelectCategoryEvent(id)),
                    ),
                    SizedBox(height: 12.h),
                    _GenderDropdown(
                      selectedId: state.selectedGenderId,
                      onChanged: (id) => context
                          .read<MyPetsBloc>()
                          .add(SelectGenderEvent(id)),
                    ),
                    SizedBox(height: 12.h),
                    _LookupDropdown(
                      label: 'Color',
                      icon: Icons.palette_outlined,
                      iconColor: AppColors.current.brown,
                      items: state.colors,
                      selectedId: state.selectedColorId,
                      onChanged: (id) => context
                          .read<MyPetsBloc>()
                          .add(SelectColorEvent(id)),
                    ),
                    SizedBox(height: 24.h),

                    _SectionLabel('Medical Records'),
                    SizedBox(height: 10.h),
                    const VaccinationBuilder(),
                    SizedBox(height: 24.h),

                    _SaveButton(
                      isSubmitting: isSubmitting,
                      onTap: () => _submit(context),
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

// ─── Top app bar ──────────────────────────────────────────────────────────────

class _FormTopBar extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onSave;

  const _FormTopBar({required this.isSubmitting, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              'Add Pet',
              style: AppTextStyles.appbar.copyWith(
                color: AppColors.current.text,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          isSubmitting
              ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.current.primary,
                  ),
                )
              : TextButton(
                  onPressed: onSave,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.current.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// ─── Save button ──────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onTap;

  const _SaveButton({required this.isSubmitting, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSubmitting ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52.h,
        decoration: BoxDecoration(
          color: isSubmitting
              ? AppColors.current.primary.withAlpha(140)
              : AppColors.current.primary,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: isSubmitting
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
          child: isSubmitting
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  'Add Pet',
                  style: AppTextStyles.bold.copyWith(
                    color: Colors.white,
                    fontSize: 15.sp,
                  ),
                ),
        ),
      ),
    );
  }
}

// ─── Shared form widgets ──────────────────────────────────────────────────────

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
        labelStyle:
            TextStyle(color: AppColors.current.midGray, fontSize: 13.sp),
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
          borderSide:
              BorderSide(color: AppColors.current.primary, width: 1.5),
        ),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
    );
  }
}

class _LookupDropdown extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final List items;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  const _LookupDropdown({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.items,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: selectedId,
          hint: Row(
            children: [
              Icon(icon, color: iconColor, size: 20.w),
              SizedBox(width: 12.w),
              Text(
                label,
                style: TextStyle(
                    color: AppColors.current.midGray, fontSize: 13.sp),
              ),
            ],
          ),
          icon: Icon(Icons.expand_more_rounded,
              color: AppColors.current.midGray, size: 20.w),
          items: items.map((item) {
            return DropdownMenuItem<int>(
              value: item.id as int,
              child: Text(
                item.name as String,
                style: TextStyle(
                    color: AppColors.current.text, fontSize: 14.sp),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          selectedItemBuilder: (context) => items.map((item) {
            return Row(
              children: [
                Icon(icon, color: iconColor, size: 20.w),
                SizedBox(width: 12.w),
                Text(
                  item.name as String,
                  style: TextStyle(
                      color: AppColors.current.text,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _GenderDropdown extends StatelessWidget {
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  const _GenderDropdown({required this.selectedId, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const genders = [
      (id: 1, name: 'Male'),
      (id: 2, name: 'Female'),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          isExpanded: true,
          value: selectedId,
          hint: Row(
            children: [
              Icon(Icons.wc_rounded,
                  color: const Color(0xFF3AAFA9), size: 20.w),
              SizedBox(width: 12.w),
              Text(
                'Gender',
                style: TextStyle(
                    color: AppColors.current.midGray, fontSize: 13.sp),
              ),
            ],
          ),
          icon: Icon(Icons.expand_more_rounded,
              color: AppColors.current.midGray, size: 20.w),
          items: genders
              .map(
                (g) => DropdownMenuItem<int>(
                  value: g.id,
                  child: Text(
                    g.name,
                    style: TextStyle(
                        color: AppColors.current.text, fontSize: 14.sp),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          selectedItemBuilder: (_) => genders
              .map(
                (g) => Row(
                  children: [
                    Icon(Icons.wc_rounded,
                        color: const Color(0xFF3AAFA9), size: 20.w),
                    SizedBox(width: 12.w),
                    Text(
                      g.name,
                      style: TextStyle(
                          color: AppColors.current.text,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
