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
import 'package:pinput/pinput.dart';

class OTPBody extends StatelessWidget {
   OTPBody({super.key});
  // Use the bloc's OTP controller so the same controller is used across flows
  // (registration and forgot-password).

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    final _otpController = bloc.otpForgotController;
    return SingleChildScrollView(
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterOtpSuccess) {
            // If there's a forgot-password email populated, navigate to reset password
            // Otherwise this is the registration flow and we navigate to verified.
            if (bloc.emailForgotController.text.isNotEmpty) {
              // navigate to reset password and pass the bloc + email + otp
              context.pushNamed('reset_password', extra: {
                'bloc': bloc,
                'email': bloc.emailForgotController.text,
                'otp': _otpController.text,
              });
              return;
            }
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
          final isLoading = state is RegisterLoading || state is AuthLoading;
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
                controller: _otpController,
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
                      // Choose the appropriate email depending on the flow
                      final resendEmail = bloc.emailRegisterController.text.isNotEmpty
                          ? bloc.emailRegisterController.text
                          : bloc.emailForgotController.text;
                      context.read<AuthBloc>().add(ResendOtpEvent(resendEmail));
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
                isLoading: isLoading,
                      onPressed: () {
                        final otp = _otpController.text;
                        context.read<AuthBloc>().add(RegisterOtpSubmitted(otp));
                      },
                      text: AppText.verify,
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
