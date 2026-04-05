import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_event.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_state.dart';

class GenderDropdown extends StatelessWidget {
  const GenderDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (prev, curr) => prev.selectedGenderId != curr.selectedGenderId,
      builder: (context, state) {
        return DropdownButtonFormField<int>(
          initialValue: state.selectedGenderId,
          onChanged: (v) => context.read<ProfileBloc>().add(UpdateGenderEvent(v)),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.current.midGray,
            size: 20.w,
          ),
          decoration: InputDecoration(
            labelText: AppText.gender,
            labelStyle: TextStyle(color: AppColors.current.midGray, fontSize: 13.sp),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Icon(Icons.wc_rounded, color: AppColors.current.primary, size: 20.w),
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
          items: [
            DropdownMenuItem(
              value: 1,
              child: Text(
                AppText.male,
                style: TextStyle(color: AppColors.current.text, fontSize: 14.sp),
              ),
            ),
            DropdownMenuItem(
              value: 2,
              child: Text(
                AppText.female,
                style: TextStyle(color: AppColors.current.text, fontSize: 14.sp),
              ),
            ),
          ],
        );
      },
    );
  }
}
