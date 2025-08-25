import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_event.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_state.dart';

class SetPasswordForm extends StatelessWidget {
  const SetPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Password', style: AppTextStyles.smallDescription),
            SizedBox(height: 4.h),
            CustomTextFormField(
              labelText: 'Password',
              hintText: 'Enter your password',
              obscureText: true,
              controller: bloc.passwordRegisterController,
              fillColor: true,
              fillColorValue: AppColors.current.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.current.lightGray),
              ),
              enablePasswordToggle: true,
            ),
            SizedBox(height: 10.h),
            Text('Confirm Password', style: AppTextStyles.smallDescription),
            SizedBox(height: 4.h),
            CustomTextFormField(
              labelText: 'Confirm Password',
              hintText: 'Confirm Password',
              obscureText: true,
              fillColor: true,
              controller: bloc.confirmPasswordController,
              fillColorValue: AppColors.current.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.current.lightGray),
              ),
              enablePasswordToggle: true,
            ),
            SizedBox(height: 20.h),
            CustomFilledButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                  RegisterStepTwoSubmitted(
                    password: bloc.passwordRegisterController.text,
                    confirmPassword: bloc.confirmPasswordController.text,
                  ),
                );
                context.go('/otp_verification');
              },
              text: 'Sign Up',
              backgroundColor: AppColors.current.primary,
              textColor: AppColors.current.white,
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    color: AppColors.current.lightText,
                    thickness: 1,
                    height: 20.h,
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  'OR',
                  style: AppTextStyles.smallDescription.copyWith(
                    color: AppColors.current.gray,
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Divider(
                    color: AppColors.current.lightText,
                    thickness: 1,

                    height: 20.h,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            CustomFilledButton(
              onPressed: () {
                // Handle login
              },
              text: 'Continue with Google',
              backgroundColor: AppColors.current.white,
              textColor: AppColors.current.lightText,
              hasLeading: true,
              leading: SvgPicture.asset('assets/icons/gmail.svg'),
            ),
            SizedBox(height: 10.h),
            CustomFilledButton(
              onPressed: () {
                // Handle login
              },
              text: 'Continue with Google',
              backgroundColor: AppColors.current.white,
              textColor: AppColors.current.lightText,
              hasLeading: true,
              leading: SvgPicture.asset('assets/icons/apple.svg'),
            ),
          ],
        );
      },
    );
  }
}
