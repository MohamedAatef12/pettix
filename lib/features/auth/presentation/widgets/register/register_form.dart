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
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_event.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_state.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    return BlocBuilder<AuthBloc,AuthState>(
      builder: (context,state) {
        if (state is RegisterLoading) {
          return CircularProgressIndicator();
        }
        if (state is RegisterFailure) {
          return Text(state.message, style: TextStyle(color: Colors.red));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full Name',style: AppTextStyles.smallDescription,),
            SizedBox(height: 4.h,),
            CustomTextFormField(
              labelText: 'Name',
              hintText: 'Enter your name',
              controller: bloc.fullNameController,
              keyboardType: TextInputType.emailAddress,
              fillColor: true,
              fillColorValue: AppColors.current.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.current.lightGray,
                ),
              ),
            ),
            SizedBox(height: 10.h,),
            Text('Email',style: AppTextStyles.smallDescription,),
            SizedBox(height: 4.h,),
            CustomTextFormField(
              labelText: 'Email',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              controller: bloc.emailRegisterController,
              fillColor: true,
              fillColorValue: AppColors.current.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.current.lightGray,
                ),
              ),
            ),
            SizedBox(height: 10.h,),
            Text('Phone Number',style: AppTextStyles.smallDescription,),
            SizedBox(height: 4.h,),
            CustomTextFormField(
              labelText: 'Phone',
              hintText: 'Enter your phone number',
              keyboardType: TextInputType.phone,
              controller: bloc.phoneController,
              fillColor: true,
              fillColorValue: AppColors.current.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.current.lightGray,
                ),
              ),
        leading: Padding(
        padding: PaddingConstants.medium,
        child: SvgPicture.asset("assets/images/english.svg", width: 20, height: 20),
        ),
            ),
            SizedBox(height: 20.h,),
            CustomFilledButton(
              onPressed: () {
               context.read<AuthBloc>().add(RegisterStepOneSubmitted(
                 email: bloc.emailRegisterController.text,
                 name: bloc.fullNameController.text,
                 phone: bloc.phoneController.text,
               ));
               context.go('/set_password');
              },
              text: 'Continue',
              backgroundColor: AppColors.current.primary,
              textColor: AppColors.current.white,

            ),
            SizedBox(
              height: 10.h,
            ),
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
                SizedBox(width: 5.w,),
                Text('OR',style: AppTextStyles.smallDescription.copyWith(
                  color: AppColors.current.gray,
                ),),
                SizedBox(width: 5.w,),
                Expanded(
                  child: Divider(
                    color: AppColors.current.lightText,
                    thickness: 1,

                    height: 20.h,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h,),
            CustomFilledButton(
              onPressed: () {
                context.read<AuthBloc>().add(GoogleLoginSubmitted(
                  rememberMe: bloc.rememberMe,
                ));
              },
              text: 'Continue with Google',
              backgroundColor: AppColors.current.white,
              textColor: AppColors.current.lightText,
              hasLeading: true,
              leading:
              SvgPicture.asset('assets/icons/gmail.svg'),

            ),
            SizedBox(
              height: 10.h,
            ),
            CustomFilledButton(
              onPressed: () {
                // Handle login
              },
              text: 'Continue with Apple',
              backgroundColor: AppColors.current.white,
              textColor: AppColors.current.lightText,
              hasLeading: true,
              leading:
              SvgPicture.asset('assets/icons/apple.svg'),

            ),
            SizedBox(height:20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have account? ',style: AppTextStyles.smallDescription.copyWith(
                  color: AppColors.current.gray,
                ),),
                GestureDetector(
                  onTap: () {
                    context.go('/login');
                  },
                  child: Text('Sign In',style: AppTextStyles.smallDescription.copyWith(
                    color: AppColors.current.primary,
                    fontWeight: FontWeight.w600,
                  ),),
                ),
              ],
            ),
          ],
        );
      }
    );
  }
}
