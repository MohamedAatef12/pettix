import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/auth_toast.dart';
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

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (_, current) =>
          current is RegisterStepTwoSuccess || current is RegisterFailure,
      listener: (context, state) {
        if (state is RegisterStepTwoSuccess) {
          AuthToast.showSuccess(
            context,
            AppText.verificationEmailSent,
            onDone: () => context.push('/otp_verification',
                extra: context.read<AuthBloc>()),
          );
        } else if (state is RegisterFailure) {
          AuthToast.showError(context, state.message);
        }
      },
      builder: (context, state) {
          final isLoading = state is RegisterLoading;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Password', style: AppTextStyles.smallDescription),
              SizedBox(height: 4.h),
              CustomTextFormField(
                hintText: AppText.enterYourEmail,
                obscureText: bloc.obscurePasswordRegister,
                controller: bloc.passwordRegisterController,
                fillColor: true,
                fillColorValue: AppColors.current.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.current.lightGray),
                ),
               enablePasswordToggle: false,
                suffixIcon: GestureDetector(
                  onTap: () {
                    bloc.add(RegisterTogglePasswordVisibility());
                  },
                  child: Icon(
                    bloc.obscurePasswordLogin
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.current.gray,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(AppText.confirmPassword, style: AppTextStyles.smallDescription),
              SizedBox(height: 4.h),
              CustomTextFormField(

                hintText: AppText.confirmPassword,
                obscureText: bloc.obscureConfirmPassword,
                fillColor: true,
                controller: bloc.confirmPasswordController,
                fillColorValue: AppColors.current.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.current.lightGray),
                ),
               enablePasswordToggle: false,
                suffixIcon: GestureDetector(
                  onTap: () {
                    bloc.add(RegisterToggleConfirmPasswordVisibility());
                  },
                  child: Icon(
                    bloc.obscurePasswordLogin
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.current.gray,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomFilledButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          RegisterStepTwoSubmitted(
                            password: bloc.passwordRegisterController.text,
                            confirmPassword: bloc.confirmPasswordController.text,
                          ),
                        );
                      },
                      text: AppText.signUp,
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
                    AppText.or,
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
                  // Handle Google login
                },
                text: AppText.continueWithGoogle,
                backgroundColor: AppColors.current.white,
                textColor: AppColors.current.lightText,
                hasLeading: true,
                leading: SvgPicture.asset('assets/icons/gmail.svg'),
              ),
              SizedBox(height: 10.h),
              CustomFilledButton(
                onPressed: () {
                  // Handle Apple login
                },
                text: AppText.continueWithApple,
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
