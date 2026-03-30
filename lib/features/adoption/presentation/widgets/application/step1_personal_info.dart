import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import '../../bloc/adoption_bloc.dart';
import '../../bloc/adoption_event.dart';

class Step1PersonalInfo extends StatelessWidget {
  const Step1PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AdoptionBloc>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              "Full Name",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.current.gray.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 5),
            CustomTextFormField(
              controller: bloc.fullNameController,
              onChanged: (val) => bloc.add(UpdateFullName(val)),
              hintText: "My name is",
              fillColor: true,
              fillColorValue: AppColors.current.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xffF0E8DB),
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xffF0E8DB),
                  width: 1.w,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xffF0E8DB),
                  width: 1.w,
                ),
              ),
            ),
            const SizedBox(height: 12),

            Text(
              "Email",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.current.gray.withValues(alpha: 0.5),
              ),
            ),

            const SizedBox(height: 5),
            CustomTextFormField(
              controller: bloc.emailController,
              onChanged: (val) => bloc.add(UpdateEmail(val)),
              hintText: "example@gmail.com",
              fillColor: true,
              fillColorValue: AppColors.current.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xffF0E8DB),
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xffF0E8DB),
                  width: 1.w,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xffF0E8DB),
                  width: 1.w,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Phone Number",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.current.gray.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 5),
            CustomTextFormField(
              controller: bloc.phoneNumberController,
              onChanged: (val) => bloc.add(UpdatePhoneNumber(val)),
              hintText: "+1 234 567 890",
              fillColor: true,
              fillColorValue: AppColors.current.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xffF0E8DB),
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xffF0E8DB),
                  width: 1.w,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xffF0E8DB),
                  width: 1.w,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Date of Birth ",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.current.gray.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 5),
            CustomTextFormField(
              controller: bloc.dobController,
              readOnly: true,
              onTap: () {
                _showDatePicker(context, bloc);
              },
              hintText: "Date of Birth (YYYY-MM-DD)",
              fillColor: true,
              fillColorValue: AppColors.current.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xffF0E8DB),
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xffF0E8DB),
                  width: 1.w,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xffF0E8DB),
                  width: 1.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context, AdoptionBloc bloc) {
    DateTime initialDate = DateTime.now();
    try {
      if (bloc.dobController.text.isNotEmpty) {
        initialDate = DateTime.parse(bloc.dobController.text);
      }
    } catch (_) {}

    showCupertinoModalPopup(
      context: context,
      builder:
          (_) => Container(
            height: 250,
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initialDate,
                    maximumDate: DateTime.now(),
                    onDateTimeChanged: (val) {
                      final formatted = DateFormat('yyyy-MM-dd').format(val);
                      bloc.dobController.text = formatted;
                      bloc.add(UpdateDateOfBirth(formatted));
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
