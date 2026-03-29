import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/app_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/auth_toast.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_event.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_state.dart';
import 'package:pinput/pinput.dart';

class OTPForgotPasswordBody extends StatelessWidget {
   OTPForgotPasswordBody({super.key});


  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    return SingleChildScrollView(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterOtpSuccess) {
             AuthToast.showSuccess(
              context,
              'Verification Successful!',
              onDone: () => context.go('/verified'),
            );
          } else if (state is RegisterFailure) {
            AuthToast.showError(context, state.message);
          } else if (state is OtpSent) {
             AuthToast.showSuccess(context, 'OTP resent successfully!');
          }
        },
        builder: (context, state) {
          final isLoading = state is ForgotPasswordLoading;
          return Column(
            children: [
              SvgPicture.asset(
                'assets/images/otp_verification.svg',
                fit: BoxFit.fill,
                width: MediaQuery.sizeOf(context).width,
              ),
              Text(AppText.otpVerification, style: AppTextStyles.title),
              SizedBox(height: 10.h,),
              Text(AppText.enterOtpSent, style: AppTextStyles.smallDescription),
              SizedBox(height: 40.h,),
              Pinput(
                length: 6,
                controller: bloc.otpForgotController,
                keyboardType: TextInputType.number,
                defaultPinTheme: PinTheme(
                  width: 60,
                  height: 60,
                  textStyle: const TextStyle(fontSize: 22),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppText.didntReceiveCode, style: AppTextStyles.smallDescription.copyWith(
                    color: AppColors.current.gray,
                  ),),
                  GestureDetector(
                    onTap: () {
                      context.read<AuthBloc>().add(ResendOtpEvent(
                        bloc.emailForgotController.text
                      ));
                    },
                    child: Text(AppText.resend, style: AppTextStyles.smallDescription.copyWith(
                      color: AppColors.current.primary,
                      fontWeight: FontWeight.w600,
                    ),),
                  ),
                ],
              ),
              SizedBox(height: 40.h,),
              CustomFilledButton(
                onPressed: () {
                  final otp = bloc.otpForgotController.text;
                  context.pushNamed(
                    'reset_password',
                    extra: {
                      'bloc': bloc,
                      'email': bloc.emailForgotController.text,
                      'otp': otp,
                    },
                  );
                },
                text: AppText.continue_,
                backgroundColor: AppColors.current.primary,
                textColor: AppColors.current.white,
              ),
              SizedBox(height: 20.h,),
            ],
          );
        },
      ),
    );
  }
}
