import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:pettix/core/themes/app_colors.dart';
import '../../bloc/adoption_bloc.dart';
import '../../bloc/adoption_event.dart';

class Step1PersonalInfo extends StatelessWidget {
  const Step1PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AdoptionBloc>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
        children: [
          _FieldLabel(label: 'Full Name', icon: Icons.person_outline_rounded),
          SizedBox(height: 8.h),
          _AdoptionField(
            controller: bloc.fullNameController,
            onChanged: (v) => bloc.add(UpdateFullName(v)),
            hint: 'Your full name',
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: 20.h),
          _FieldLabel(label: 'Email Address', icon: Icons.email_outlined),
          SizedBox(height: 8.h),
          _AdoptionField(
            controller: bloc.emailController,
            onChanged: (v) => bloc.add(UpdateEmail(v)),
            hint: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: 20.h),
          _FieldLabel(label: 'Phone Number', icon: Icons.phone_outlined),
          SizedBox(height: 8.h),
          _AdoptionField(
            controller: bloc.phoneNumberController,
            onChanged: (v) => bloc.add(UpdatePhoneNumber(v)),
            hint: '+1 234 567 890',
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 20.h),
          _FieldLabel(label: 'Date of Birth', icon: Icons.cake_outlined),
          SizedBox(height: 8.h),
          _AdoptionField(
            controller: bloc.dobController,
            onChanged: (_) {},
            hint: 'Tap to select',
            readOnly: true,
            suffixIcon: Icon(
              Icons.calendar_today_rounded,
              size: 18.w,
              color: AppColors.current.primary,
            ),
            onTap: () => _showDatePicker(context, bloc),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context, AdoptionBloc bloc) {
    DateTime selected = DateTime(1990);
    try {
      if (bloc.dobController.text.isNotEmpty) {
        selected = DateTime.parse(bloc.dobController.text);
      }
      // ignore: empty_catches
    } catch (_) {}

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 320.h,
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Date of Birth',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: AppColors.current.text,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: AppColors.current.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.current.lightGray),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: selected,
                maximumDate: DateTime.now(),
                minimumDate: DateTime(1900),
                onDateTimeChanged: (val) {
                  final fmt = DateFormat('yyyy-MM-dd').format(val);
                  bloc.dobController.text = fmt;
                  bloc.add(UpdateDateOfBirth(fmt));
                },
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

  const _AdoptionField({
    required this.controller,
    required this.onChanged,
    required this.hint,
    this.readOnly = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
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
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
