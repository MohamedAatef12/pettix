import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_event.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_state.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordBody extends StatelessWidget {
  final String email;
  final String otp;
  const ResetPasswordBody({super.key, required this.email, required this.otp});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    return Padding(
      padding: PaddingConstants.large,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // navigate to password reset done
            context.pushNamed('password_reset_done');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
          Text(AppText.newPassword,
          style: AppTextStyles.title,),
          SizedBox(height: 4.h,),
          Text(AppText.enterNewPassword,
          style: AppTextStyles.description,
          ),
          SizedBox(height: 30.h,),
              Text(AppText.password,style: AppTextStyles.smallDescription,),
              SizedBox(height: 4.h,),
              CustomTextFormField(
                controller: bloc.newPasswordForgotController,
                hintText: AppText.enterPassword,
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
              Text(AppText.confirmPassword,style: AppTextStyles.smallDescription,),
              SizedBox(height: 4.h,),
              CustomTextFormField(
                controller: bloc.confirmNewPasswordForgotController,
                hintText: AppText.confirmPassword,
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
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomFilledButton(
                      onPressed: () {
                        final newPass = bloc.newPasswordForgotController.text;
                        final confirm = bloc.confirmNewPasswordForgotController.text;
                        context.read<AuthBloc>().add(ResetPasswordEvent(
                          email: email,
                          otp: otp,
                          newPassword: newPass,
                          confirmPassword: confirm,
                        ));
                      },
                      text: AppText.resetPassword,
                      backgroundColor: AppColors.current.primary,
                      textColor: AppColors.current.white,

                    ),
              SizedBox(
                height: 10.h,
              ),
            ],
          );
        },
      ),
    );
  }
}
