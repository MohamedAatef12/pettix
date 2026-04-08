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
import 'package:pettix/features/auth/data/models/login/login_model.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_event.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_state.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Required";
    if (value.length < 8) return "Password must be at least 8 characters";
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Must contain at least one uppercase letter";
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Must contain at least one lowercase letter";
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return "Must contain at least one number";
    }
    return null;
  }

  void _showActivateEmailDialog(BuildContext context) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final authBloc = context.read<AuthBloc>();

    showDialog(
      context: context,
      builder: (ctx) {
        return BlocListener<AuthBloc, AuthState>(
          bloc: authBloc,
          listener: (context, state) {
            if (state is OtpSent) {
              AuthToast.showSuccess(
                context,
                'OTP sent! Please check your email.',
                onDone: () {
                   Navigator.of(ctx).pop(); // Close dialog
                  context.push('/otp_verification', extra: authBloc);
                }
              );
            } else if (state is RegisterFailure) {
              AuthToast.showError(context, state.message);
            }
          },
          child: AlertDialog(
            backgroundColor: AppColors.current.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppText.activateEmail,
                  style: AppTextStyles.bodyTitle.copyWith(
                    color: AppColors.current.primary,
                  ),
                ),
                  SizedBox(width: 8.w),
                Icon(Icons.verified,
                color: AppColors.current.primary, size: 20.r),
              ],
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppText.email, style: AppTextStyles.smallDescription),
                  SizedBox(height: 8.h),
                  CustomTextFormField(
                    controller: emailController,
                    hintText: AppText.enterYourEmail,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppText.required;
                      } else if (!_isValidEmail(value)) {
                        return AppText.validEmail;
                      }
                      return null;
                    },
                    fillColor: true,
                    fillColorValue: AppColors.current.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: AppColors.current.lightGray),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  BlocBuilder<AuthBloc, AuthState>(
                    bloc: authBloc,
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return
                           Center(
                            child: CustomFilledButton(
                              isLoading: isLoading,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    authBloc.add(
                                        ResendOtpEvent(emailController.text));
                                  }
                                },
                                text: AppText.sendOtp,
                                backgroundColor: AppColors.current.primary,
                                textColor: AppColors.current.white,
                              ),
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();

    return Form(
      key: bloc.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.email, style: AppTextStyles.smallDescription),
          SizedBox(height: 4.h),
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: CustomTextFormField(
              controller: bloc.emailLoginController,
              hintText: AppText.enterYourEmail,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppText.required;
                } else if (!_isValidEmail(value)) {
                  return AppText.validEmail;
                }
                return null;
              },
              fillColor: true,
              fillColorValue: AppColors.current.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.current.lightGray),
              ),
            ),
          ),
          SizedBox(height: 10.h),

          Text(AppText.password, style: AppTextStyles.smallDescription),
          SizedBox(height: 4.h),
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen:
                (previous, current) =>
                    current is LoginPasswordVisibilityChanged,
            builder: (context, state) {
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: CustomTextFormField(
                  controller: bloc.passwordLoginController,
                  hintText: AppText.enterPassword,
                  validator: (value) =>
                  (value == null || value.isEmpty) ? AppText.passwordRequired : null,
                  fillColor: true,
                  fillColorValue: AppColors.current.white,
                  obscureText: bloc.obscurePasswordLogin,
                  enablePasswordToggle: false,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      bloc.add(LoginTogglePasswordVisibility());
                    },
                    child: Icon(
                      bloc.obscurePasswordLogin
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.current.gray,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.current.lightGray),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 1.h),

        BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) => current is LoginRememberMeChanged,
            builder: (context, state) {
              return Padding(
                padding: PaddingConstants.horizontalSmall,
                child: Row(
                  children: [
                    Checkbox(
                      value: bloc.rememberMe,
                      onChanged: (value) => bloc.add(ToggleRememberMe(value!)),
                      activeColor: AppColors.current.green,
                    ),
                    Text(
                      AppText.rememberMe,
                      style: AppTextStyles.smallDescription.copyWith(
                        color: AppColors.current.gray,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => context.pushNamed('forgot_password'),
                      child: Text(
                        AppText.forgetPassword,
                        style: AppTextStyles.smallDescription.copyWith(
                          color: AppColors.current.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              bloc.emailLoginController.clear();
              bloc.passwordLoginController.clear();
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isAnyLoading = state is LoginLoading || state is GoogleLoginLoading || state is AuthLoading;
              return CustomFilledButton(
                isLoading: state is LoginLoading,
                onPressed: isAnyLoading ? null : () {
                  if (bloc.loginFormKey.currentState!.validate()) {
                    bloc.add(
                      LoginSubmitted(
                        model: LoginModel(
                          email: bloc.emailLoginController.text,
                          password: bloc.passwordLoginController.text,
                        ),
                        rememberMe: bloc.rememberMe,
                      ),
                    );
                  }
                },
                text: AppText.signIn,
                backgroundColor: AppColors.current.primary,
                textColor: AppColors.current.white,
              );
            },
          ),
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
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isAnyLoading = state is LoginLoading || state is GoogleLoginLoading || state is AuthLoading;
              return CustomFilledButton(
                isLoading: state is GoogleLoginLoading,
                onPressed: isAnyLoading ? null : () {
                  context.read<AuthBloc>().add(
                    GoogleLoginSubmitted(rememberMe: bloc.rememberMe),
                  );
                },
                text: AppText.continueWithGoogle,
                backgroundColor: AppColors.current.white,
                textColor: AppColors.current.lightText,
                hasLeading: true,
                leading: SvgPicture.asset('assets/icons/gmail.svg'),
              );
            },
          ),
          SizedBox(height: 10.h),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isAnyLoading = state is LoginLoading || state is GoogleLoginLoading || state is AuthLoading;
              return CustomFilledButton(
                onPressed: isAnyLoading ? null : () {
                  // Handle login
                },
                text: AppText.continueWithApple,
                backgroundColor: AppColors.current.white,
                textColor: AppColors.current.lightText,
                hasLeading: true,
                leading: SvgPicture.asset('assets/icons/apple.svg'),
                isLoading: false, // Could add AppleLoginLoading if available
              );
            },
          ),
          SizedBox(height: 20.h),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppText.dontHaveAccount,
                    style: AppTextStyles.smallDescription.copyWith(
                      color: AppColors.current.gray,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/signup');
                    },
                    child: Text(
                      AppText.signUp,
                      style: AppTextStyles.smallDescription.copyWith(
                        color: AppColors.current.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),]),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppText.emailNotVerified,
                    style: AppTextStyles.smallDescription.copyWith(
                      color: AppColors.current.gray,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showActivateEmailDialog(context);
                    },
                    child: Text(
                      AppText.activateEmail,
                      style: AppTextStyles.smallDescription.copyWith(
                        color: AppColors.current.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
