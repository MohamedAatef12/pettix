import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import '../../bloc/adoption_bloc.dart';
import '../../bloc/adoption_event.dart';
import '../../bloc/adoption_state.dart';

class Step1PersonalInfo extends StatelessWidget {
  const Step1PersonalInfo({super.key});

  String _formatDateInEnglish(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  // Validation methods
  String? _getNameError(String value, bool isSubmitted) {
    if (!isSubmitted && value.isEmpty) return null;
    if (value.isEmpty) return AppText.fullNameRequired;
    if (value.trim().length < 3) return AppText.nameMinLength;
    if (!value.trim().contains(' ')) return AppText.firstAndLastName;
    return null;
  }

  String? _getEmailError(String value, bool isSubmitted) {
    if (!isSubmitted && value.isEmpty) return null;
    if (value.isEmpty) return AppText.emailAddressRequired;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return AppText.enterValidEmail;
    return null;
  }

  String? _getPhoneError(String value, bool isSubmitted) {
    if (!isSubmitted && value.isEmpty) return null;
    if (value.isEmpty) return AppText.phoneNumberRequired;
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (cleanPhone.length != 11) return AppText.phoneNumberElevenDigits;
    return null;
  }

  String? _getDobError(String value, bool isSubmitted) {
    if (!isSubmitted && value.isEmpty) return null;
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

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AdoptionBloc>();

    return BlocBuilder<AdoptionBloc, AdoptionState>(
      builder: (context, state) {
        // Helper local validity checks
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

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
            physics: const BouncingScrollPhysics(),
            children: [
              _FieldLabel(
                label: AppText.fullName,
                icon: Icons.person_outline_rounded,
              ),
              SizedBox(height: 8.h),
              _AdoptionField(
                controller: bloc.fullNameController,
                onChanged: (v) {
                  bloc.add(UpdateFullName(v));
                },
                hint: AppText.yourFullName,
                keyboardType: TextInputType.name,
                errorText: _getNameError(state.fullName, state.isSubmitted),
                isValid: isNameValid,
              ),
              SizedBox(height: 20.h),
              _FieldLabel(
                label: AppText.emailAddress,
                icon: Icons.email_outlined,
              ),
              SizedBox(height: 8.h),
              _AdoptionField(
                controller: bloc.emailController,
                onChanged: (v) {
                  bloc.add(UpdateEmail(v));
                },
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                errorText: _getEmailError(state.email, state.isSubmitted),
                isValid: isEmailValid,
              ),
              SizedBox(height: 20.h),
              _FieldLabel(
                label: AppText.phoneNumber,
                icon: Icons.phone_outlined,
              ),
              SizedBox(height: 8.h),
              _AdoptionField(
                controller: bloc.phoneNumberController,
                onChanged: (v) {
                  bloc.add(UpdatePhoneNumber(v));
                },
                hint: '01xxxxxxxxx',
                keyboardType: TextInputType.phone,
                errorText: _getPhoneError(state.phoneNumber, state.isSubmitted),
                isValid: isPhoneValid,
              ),
              SizedBox(height: 20.h),
              _FieldLabel(
                label: AppText.dateOfBirth,
                icon: Icons.cake_outlined,
              ),
              SizedBox(height: 8.h),
              _AdoptionField(
                controller: bloc.dobController,
                onChanged: (_) {},
                hint: AppText.tapToSelect,
                readOnly: true,
                suffixIcon: Icon(
                  Icons.calendar_today_rounded,
                  size: 18.w,
                  color: AppColors.current.primary,
                ),
                onTap: () => _showDatePicker(context, bloc),
                errorText: _getDobError(state.dateOfBirth, state.isSubmitted),
                isValid: isDobValid,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePicker(BuildContext context, AdoptionBloc bloc) {
    DateTime selected = DateTime(1995, 1, 1);
    try {
      if (bloc.dobController.text.isNotEmpty) {
        selected = DateTime.parse(bloc.dobController.text);
      }
      // ignore: empty_catches
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
                // Drag handle
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

                // Header: Cancel | Title | Confirm
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
                          final fmt = _formatDateInEnglish(selected);
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

                // Branded Cupertino Date Picker container
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
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const _FieldLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.w, color: AppColors.current.primary),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.current.text,
          ),
        ),
      ],
    );
  }
}

class _AdoptionField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final String? errorText;
  final bool isValid;

  const _AdoptionField({
    required this.controller,
    required this.onChanged,
    required this.hint,
    this.readOnly = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.errorText,
    this.isValid = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: AppColors.current.lightGray, width: 1.5),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: AppColors.current.primary, width: 1.5),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: AppColors.current.red, width: 1.5),
    );

    // Dynamic Suffix Icon based on validation status
    final Widget? finalSuffixIcon =
        isValid
            ? Icon(Icons.check_circle_rounded, color: Colors.green, size: 20.w)
            : suffixIcon;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 14.sp, color: AppColors.current.text),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.current.midGray),
        filled: true,
        fillColor: AppColors.current.white,
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        errorText: errorText,
        errorStyle: TextStyle(
          fontSize: 12.sp,
          color: AppColors.current.red,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        suffixIcon: finalSuffixIcon,
      ),
    );
  }
}
