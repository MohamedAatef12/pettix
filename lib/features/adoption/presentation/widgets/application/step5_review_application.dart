import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import '../../bloc/adoption_bloc.dart';
import '../../bloc/adoption_event.dart';
import '../../bloc/adoption_state.dart';

class StepReviewApplication extends StatelessWidget {
  const StepReviewApplication({super.key});

  // Validation methods
  String? _getNameError(String value) {
    if (value.isEmpty) return AppText.fullNameRequired;
    if (value.trim().length < 3) return AppText.nameMinLength;
    if (!value.trim().contains(' ')) return AppText.firstAndLastName;
    return null;
  }

  String? _getEmailError(String value) {
    if (value.isEmpty) return AppText.emailAddressRequired;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return AppText.enterValidEmail;
    return null;
  }

  String? _getPhoneError(String value) {
    if (value.isEmpty) return AppText.phoneNumberRequired;
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (cleanPhone.length != 11) return AppText.phoneNumberElevenDigits;
    return null;
  }

  String? _getDobError(String value) {
    if (value.isEmpty) return AppText.dateOfBirthRequired;
    try {
      final dob = DateTime.parse(value);
      final today = DateTime.now();
      int age = today.year - dob.year;
      if (today.month < dob.month ||
          (today.month == dob.month && today.day < dob.day)) {
        age--;
      }
      if (age < 18) return AppText.mustBeAdultToAdopt;
    } catch (_) {
      return AppText.invalidDateFormat;
    }
    return null;
  }

  void _showDatePicker(BuildContext context, AdoptionBloc bloc) {
    DateTime selected = DateTime(1995, 1, 1);
    try {
      if (bloc.dobController.text.isNotEmpty) {
        selected = DateTime.parse(bloc.dobController.text);
      }
    } catch (_) {}

    showModalBottomSheet(
      backgroundColor: AppColors.current.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder:
          (_) => Container(
            padding: EdgeInsets.only(bottom: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.current.lightGray,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          AppText.cancel,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.current.lightText,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        AppText.selectDateOfBirth,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.current.text,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final fmt = DateFormat('yyyy-MM-dd').format(selected);
                          bloc.dobController.text = fmt;
                          bloc.add(UpdateDateOfBirth(fmt));
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppText.confirm,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.current.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  height: 180.h,
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: AppColors.current.lightBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        dateTimePickerTextStyle: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.current.text,
                        ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: selected,
                      maximumDate: DateTime.now(),
                      minimumDate: DateTime(1900),
                      onDateTimeChanged: (val) {
                        selected = val;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  String _getLivingSituationName(AdoptionState state) {
    try {
      return state.options!.livingSituations
          .firstWhere((e) => e.id == state.selectedLivingSituationId)
          .name;
    } catch (_) {
      return '—';
    }
  }

  String _getResidenceTypeName(AdoptionState state) {
    try {
      return state.options!.residenceTypes
          .firstWhere((e) => e.id == state.selectedResidenceTypeId)
          .name;
    } catch (_) {
      return '—';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AdoptionBloc>();

    return BlocBuilder<AdoptionBloc, AdoptionState>(
      builder: (context, state) {
        // Validation Checks for Personal Info
        final isNameValid =
            state.fullName.isNotEmpty &&
            state.fullName.trim().length >= 3 &&
            state.fullName.trim().contains(' ');

        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        final isEmailValid =
            state.email.isNotEmpty && emailRegex.hasMatch(state.email);

        final cleanPhone = state.phoneNumber.replaceAll(
          RegExp(r'[\s\-\(\)\+]'),
          '',
        );
        final isPhoneValid =
            state.phoneNumber.isNotEmpty && cleanPhone.length == 11;

        bool isDobValid = false;
        if (state.dateOfBirth.isNotEmpty) {
          try {
            final dob = DateTime.parse(state.dateOfBirth);
            final today = DateTime.now();
            int age = today.year - dob.year;
            if (today.month < dob.month ||
                (today.month == dob.month && today.day < dob.day)) {
              age--;
            }
            isDobValid = age >= 18;
          } catch (_) {}
        }

        final isPersonalValid =
            isNameValid && isEmailValid && isPhoneValid && isDobValid;

        // Validation Checks for Living
        final isLivingValid =
            state.selectedLivingSituationId != null &&
            state.selectedResidenceTypeId != null;

        // Validation Checks for Pet Experience
        final isPetValid =
            state.hasOwnedPetBefore != null &&
            (state.hasOwnedPetBefore == false ||
                (state.petType != null && state.petType!.isNotEmpty));

        return ListView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              AppText.reviewBeforeSubmitting,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.current.midGray,
                height: 1.5,
              ),
            ),
            SizedBox(height: 20.h),

            // 1. Personal Information Card
            _ReviewCard(
              title: AppText.personalInformation,
              icon: Icons.person_outline_rounded,
              isEditing: state.isEditingPersonal,
              isEnabled: !state.isEditingPersonal || isPersonalValid,
              onEditToggle: () {
                bloc.add(const ToggleEditingPersonal());
              },
              children:
                  state.isEditingPersonal
                      ? [
                        _InlineEditRow(
                          label: AppText.fullName,
                          child: _InlineTextField(
                            controller: bloc.fullNameController,
                            onChanged: (v) => bloc.add(UpdateFullName(v)),
                            hint: AppText.fullName,
                            keyboardType: TextInputType.name,
                            errorText: _getNameError(state.fullName),
                            isValid: isNameValid,
                          ),
                        ),
                        _InlineEditRow(
                          label: AppText.email,
                          child: _InlineTextField(
                            controller: bloc.emailController,
                            onChanged: (v) => bloc.add(UpdateEmail(v)),
                            hint: AppText.emailAddress,
                            keyboardType: TextInputType.emailAddress,
                            errorText: _getEmailError(state.email),
                            isValid: isEmailValid,
                          ),
                        ),
                        _InlineEditRow(
                          label: AppText.phone,
                          child: _InlineTextField(
                            controller: bloc.phoneNumberController,
                            onChanged: (v) => bloc.add(UpdatePhoneNumber(v)),
                            hint: AppText.phoneNumber,
                            keyboardType: TextInputType.phone,
                            errorText: _getPhoneError(state.phoneNumber),
                            isValid: isPhoneValid,
                          ),
                        ),
                        _InlineEditRow(
                          label: AppText.dateOfBirth,
                          child: _InlineTextField(
                            controller: bloc.dobController,
                            onChanged: (_) {},
                            hint: AppText.dateOfBirth,
                            readOnly: true,
                            onTap: () => _showDatePicker(context, bloc),
                            errorText: _getDobError(state.dateOfBirth),
                            isValid: isDobValid,
                          ),
                        ),
                      ]
                      : [
                        _ReviewRow(
                          label: AppText.fullName,
                          value: state.fullName,
                        ),
                        _ReviewRow(label: AppText.email, value: state.email),
                        _ReviewRow(
                          label: AppText.phone,
                          value: state.phoneNumber,
                        ),
                        _ReviewRow(
                          label: AppText.dateOfBirth,
                          value: state.dateOfBirth,
                        ),
                      ],
            ),
            SizedBox(height: 12.h),

            // 2. Living Situation Card
            _ReviewCard(
              title: AppText.livingSituation,
              icon: Icons.home_outlined,
              isEditing: state.isEditingLiving,
              isEnabled: !state.isEditingLiving || isLivingValid,
              onEditToggle: () {
                bloc.add(const ToggleEditingLiving());
              },
              children:
                  state.isEditingLiving
                      ? [
                        _InlineSelectRow(
                          label: AppText.livingSituation,
                          options: state.options?.livingSituations ?? [],
                          selectedId: state.selectedLivingSituationId,
                          onSelect: (id) => bloc.add(UpdateLivingSituation(id)),
                        ),
                        SizedBox(height: 12.h),
                        _InlineSelectRow(
                          label: AppText.typeOfResidence,
                          options: state.options?.residenceTypes ?? [],
                          selectedId: state.selectedResidenceTypeId,
                          onSelect: (id) => bloc.add(UpdateResidenceType(id)),
                        ),
                      ]
                      : [
                        _ReviewRow(
                          label: AppText.livingSituation,
                          value: _getLivingSituationName(state),
                        ),
                        _ReviewRow(
                          label: AppText.typeOfResidence,
                          value: _getResidenceTypeName(state),
                        ),
                      ],
            ),
            SizedBox(height: 12.h),

            // 3. Pet Experience Card
            _ReviewCard(
              title: AppText.petExperience,
              icon: Icons.pets_rounded,
              isEditing: state.isEditingPet,
              isEnabled: !state.isEditingPet || isPetValid,
              onEditToggle: () {
                bloc.add(const ToggleEditingPet());
              },
              children:
                  state.isEditingPet
                      ? [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppText.haveOwnedPetBefore,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.current.midGray,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                _ChoiceChip(
                                  label: AppText.yes,
                                  isSelected: state.hasOwnedPetBefore == true,
                                  onTap:
                                      () => bloc.add(
                                        const UpdateHasOwnedPet(true),
                                      ),
                                ),
                                SizedBox(width: 8.w),
                                _ChoiceChip(
                                  label: AppText.no,
                                  isSelected: state.hasOwnedPetBefore == false,
                                  onTap:
                                      () => bloc.add(
                                        const UpdateHasOwnedPet(false),
                                      ),
                                ),
                              ],
                            ),
                            if (state.hasOwnedPetBefore == true) ...[
                              SizedBox(height: 14.h),
                              _InlineEditRow(
                                label: AppText.typeOfPet,
                                child: _InlineTextField(
                                  controller: bloc.petTypeController,
                                  onChanged: (v) => bloc.add(UpdatePetType(v)),
                                  hint: AppText.petTypeHint,
                                  errorText:
                                      state.petType == null ||
                                              state.petType!.isEmpty
                                          ? AppText.petTypeRequired
                                          : null,
                                  isValid:
                                      state.petType != null &&
                                      state.petType!.isNotEmpty,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ]
                      : [
                        _ReviewRow(
                          label: AppText.ownedPetBefore,
                          value:
                              state.hasOwnedPetBefore == true
                                  ? AppText.yes
                                  : AppText.no,
                        ),
                        if (state.hasOwnedPetBefore == true)
                          _ReviewRow(
                            label: AppText.typeOfPet,
                            value: state.petType ?? '—',
                          ),
                      ],
            ),
            SizedBox(height: 28.h),

            // Submit Button — shows spinner while API is in progress
            _SubmitButton(
              isSubmitting: state.status == AdoptionStatus.submitting,
            ),
          ],
        );
      },
    );
  }
}

// ─── Reusable Review Card ───────────────────────────────────────────────────

class _ReviewCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isEditing;
  final bool isEnabled;
  final VoidCallback onEditToggle;
  final List<Widget> children;

  const _ReviewCard({
    required this.title,
    required this.icon,
    required this.isEditing,
    required this.isEnabled,
    required this.onEditToggle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.current.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 8.w, 12.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    color: AppColors.current.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    icon,
                    size: 16.w,
                    color: AppColors.current.primary,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.current.text,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: isEnabled ? onEditToggle : null,
                  icon: Icon(
                    isEditing
                        ? Icons.check_circle_rounded
                        : Icons.edit_outlined,
                    size: 20.w,
                    color:
                        isEditing
                            ? (isEnabled
                                ? Colors.green
                                : Colors.grey.withValues(alpha: 0.4))
                            : AppColors.current.primary,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: isEditing ? AppText.done : AppText.edit,
                ),
                SizedBox(width: 8.w),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.current.lightGray),
          // Card Body
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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

// ─── Inline Textfield Row (Personal Info Right-Aligned) ──────────────────────────

class _InlineEditRow extends StatelessWidget {
  final String label;
  final Widget child;

  const _InlineEditRow({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: SizedBox(
              width: 100.w,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.current.midGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _InlineTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? errorText;
  final bool isValid;

  const _InlineTextField({
    required this.controller,
    required this.onChanged,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
    this.errorText,
    this.isValid = false,
  });

  @override
  Widget build(BuildContext context) {
    final Widget? finalSuffixIcon =
        isValid
            ? Icon(Icons.check_circle_rounded, color: Colors.green, size: 16.w)
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 38.h,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.current.text,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: AppColors.current.midGray,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 8.h,
              ),
              filled: true,
              fillColor: AppColors.current.lightBlue.withValues(alpha: 0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: AppColors.current.primary,
                  width: 1.r,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: AppColors.current.red,
                  width: 1.r,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: AppColors.current.red,
                  width: 1.r,
                ),
              ),
              suffixIcon: finalSuffixIcon,
            ),
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              errorText!,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.current.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Inline Select Row (Horizontal Scrolling Choices) ──────────────────────────

class _InlineSelectRow extends StatelessWidget {
  final String label;
  final List<dynamic> options;
  final int? selectedId;
  final ValueChanged<int> onSelect;

  const _InlineSelectRow({
    required this.label,
    required this.options,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.current.midGray,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children:
                options.map((item) {
                  final isSelected = item.id == selectedId;
                  return GestureDetector(
                    onTap: () => onSelect(item.id),
                    child: Container(
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppColors.current.primary
                                : AppColors.current.lightBlue.withValues(
                                  alpha: 0.2,
                                ),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color:
                              isSelected
                                  ? Colors.transparent
                                  : AppColors.current.lightGray,
                          width: 1.r,
                        ),
                      ),
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color:
                              isSelected
                                  ? Colors.white
                                  : AppColors.current.text,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}

// ─── Reusable Choice Chip ───────────────────────────────────────────────────

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChoiceChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.current.primary
                  : AppColors.current.lightBlue.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color:
                isSelected ? Colors.transparent : AppColors.current.lightGray,
            width: 1.r,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.current.text,
          ),
        ),
      ),
    );
  }
}

// ─── Normal Static Row ──────────────────────────────────────────────────────

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReviewRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.current.midGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.current.text,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Loading-Aware Submit Button ─────────────────────────────────────────────

class _SubmitButton extends StatelessWidget {
  final bool isSubmitting;

  const _SubmitButton({required this.isSubmitting});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child:
          isSubmitting
              ? Container(
                key: const ValueKey('loading'),
                height: MediaQuery.of(context).size.height * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.current.primary,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Center(
                  child: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                ),
              )
              : CustomFilledButton(
                key: const ValueKey('button'),
                onPressed:
                    () => context.read<AdoptionBloc>().add(
                      const SubmitAdoptionForm(),
                    ),
                text: AppText.submitApplication,
                heightFactor: 0.065,
                backgroundColor: AppColors.current.primary,
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.current.white,
                ),
              ),
    );
  }
}
