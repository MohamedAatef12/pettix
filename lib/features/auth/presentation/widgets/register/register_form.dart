import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/auth_toast.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_event.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_state.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (_, current) =>
          current is RegisterStepOneSuccess || current is RegisterFailure,
      listener: (context, state) {
        if (state is RegisterStepOneSuccess) {
          AuthToast.showSuccess(
            context,
            'Info saved! Set your password.',
            onDone: () =>
                context.push('/set_password', extra: context.read<AuthBloc>()),
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
            Text(AppText.fullName, style: AppTextStyles.smallDescription),
            SizedBox(height: 4.h),
            CustomTextFormField(
              hintText: AppText.enterName,
              controller: bloc.fullNameController,
              keyboardType: TextInputType.emailAddress,
              fillColor: true,
              fillColorValue: AppColors.current.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.current.lightGray),
              ),
            ),
            SizedBox(height: 10.h),
            Text(AppText.email, style: AppTextStyles.smallDescription),
            SizedBox(height: 4.h),
            CustomTextFormField(
              hintText: AppText.enterYourEmail,
              keyboardType: TextInputType.emailAddress,
              controller: bloc.emailRegisterController,
              fillColor: true,
              fillColorValue: AppColors.current.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.current.lightGray),
              ),
            ),
            SizedBox(height: 10.h),
            Text(AppText.phoneNumber, style: AppTextStyles.smallDescription),
            SizedBox(height: 4.h),
            CustomTextFormField(
              hintText: AppText.enterPhoneNumber,
              keyboardType: TextInputType.phone,
              controller: bloc.phoneController,
              fillColor: true,
              fillColorValue: AppColors.current.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.current.lightGray),
              ),
            ),
            SizedBox(height: 20.h),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomFilledButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(RegisterStepOneSubmitted(
                        email: bloc.emailRegisterController.text,
                        name: bloc.fullNameController.text,
                        phone: bloc.phoneController.text,
                      ));
                    },
                    text: AppText.continue_,
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
                  style: AppTextStyles.smallDescription
                      .copyWith(color: AppColors.current.gray),
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
                context.read<AuthBloc>().add(
                  GoogleLoginSubmitted(rememberMe: bloc.rememberMe),
                );
              },
              text: AppText.continueWithGoogle,
              backgroundColor: AppColors.current.white,
              textColor: AppColors.current.lightText,
              hasLeading: true,
              leading: SvgPicture.asset('assets/icons/gmail.svg'),
            ),
            SizedBox(height: 10.h),
            CustomFilledButton(
              onPressed: () {},
              text: AppText.continueWithApple,
              backgroundColor: AppColors.current.white,
              textColor: AppColors.current.lightText,
              hasLeading: true,
              leading: SvgPicture.asset('assets/icons/apple.svg'),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppText.alreadyHaveAccount,
                  style: AppTextStyles.smallDescription
                      .copyWith(color: AppColors.current.gray),
                ),
                GestureDetector(
                  onTap: () => context.go('/login'),
                  child: Text(
                    AppText.signIn,
                    style: AppTextStyles.smallDescription.copyWith(
                      color: AppColors.current.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
