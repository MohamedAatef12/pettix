import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';

class ResetPasswordBody extends StatelessWidget {
  const ResetPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
      Text('New Password',
      style: AppTextStyles.title,),
      SizedBox(height: 4.h,),
      Text('Please enter your new password.',
      style: AppTextStyles.description,
      ),
      SizedBox(height: 30.h,),
          Text('Password',style: AppTextStyles.smallDescription,),
          SizedBox(height: 4.h,),
          CustomTextFormField(
            labelText: 'Password',
            hintText: 'Enter your password',
            obscureText: true,
            fillColor: true,
            fillColorValue: AppColors.current.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.current.lightGray,
              ),
            ),
            enablePasswordToggle: true,
          ),
          SizedBox(height: 10.h,),
          Text('Confirm Password',style: AppTextStyles.smallDescription,),
          SizedBox(height: 4.h,),
          CustomTextFormField(
            labelText: 'Confirm Password',
            hintText: 'Confirm Password',
            obscureText: true,
            fillColor: true,
            fillColorValue: AppColors.current.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.current.lightGray,
              ),
            ),
            enablePasswordToggle: true,
          ),
          Spacer(),
          CustomFilledButton(
            onPressed: () {
              // Handle login
            },
            text: 'Reset Password',
            backgroundColor: AppColors.current.primary,
            textColor: AppColors.current.white,

          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }
}
