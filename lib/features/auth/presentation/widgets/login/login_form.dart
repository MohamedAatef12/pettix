import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/features/auth/data/models/login/login_model.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_event.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_state.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();

    return Form(
      key: bloc.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Email or phone number', style: AppTextStyles.smallDescription),
          SizedBox(height: 4.h),
          CustomTextFormField(
            controller: bloc.emailLoginController,
            labelText: 'Email',
            hintText: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
            (value == null || value.isEmpty) ? "Required" : null,
            fillColor: true,
            fillColorValue: AppColors.current.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.current.lightGray),
            ),
          ),
          SizedBox(height: 10.h),

          Text('Password', style: AppTextStyles.smallDescription),
          SizedBox(height: 4.h),

          // 👇 خلي BlocBuilder هنا بس
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) =>
            current is LoginPasswordVisibilityChanged,
            builder: (context, state) {
              return CustomTextFormField(
                controller: bloc.passwordLoginController,
                labelText: 'Password',
                hintText: 'Enter your password',

                validator: (value) =>
                (value == null || value.isEmpty) ? "Required" : null,
                fillColor: true,
                fillColorValue: AppColors.current.white,
                enablePasswordToggle: true,
                onToggleObscureText: () {
                  bloc.add(LoginTogglePasswordVisibility());
                },
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.current.lightGray),
                ),
              );
            },
          ),

          SizedBox(height: 1.h),

          // 👇 برضه هنا BlocBuilder للـ RememberMe بس
          BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (previous, current) =>
            current is LoginRememberMeChanged,
            builder: (context, state) {
              return Padding(
                padding: PaddingConstants.horizontalSmall,
                child: Row(
                  children: [
                    Checkbox(
                      value: bloc.rememberMe,
                      onChanged: (value) =>
                          bloc.add(ToggleRememberMe(value!)),
                      activeColor: AppColors.current.green,
                    ),
                    Text(
                      'Remember Me',
                      style: AppTextStyles.smallDescription.copyWith(
                        color: AppColors.current.gray,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.pushNamed('forgot_password'),
                      child: Text(
                        'Forget Password?',
                        style: AppTextStyles.smallDescription.copyWith(
                          color: AppColors.current.gray,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 20.h),
          CustomFilledButton(
            onPressed: () {
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
            text: 'Sign In',
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
              context.read<AuthBloc>().add(GoogleLoginSubmitted());
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
            text: 'Continue with Apple',
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
                'Don\'t have an account? ',
                style: AppTextStyles.smallDescription.copyWith(
                  color: AppColors.current.gray,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/signup');
                },
                child: Text(
                  'Sign Up',
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
    );
  }
}

