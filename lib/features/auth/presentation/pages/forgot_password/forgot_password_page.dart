import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/auth_toast.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/core/widgets/rtl_aware_icon.dart';
import 'package:pettix/data/network/email_auth_service.dart';
import 'package:pettix/features/auth/domain/usecases/forgot_password.dart';
import 'package:pettix/features/auth/domain/usecases/google_login_use_case.dart';
import 'package:pettix/features/auth/domain/usecases/login_use_case.dart';
import 'package:pettix/features/auth/domain/usecases/register_usecase.dart';
import 'package:pettix/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:pettix/features/auth/domain/usecases/reset_password.dart';
import 'package:pettix/features/auth/domain/usecases/verify_otp.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_event.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_state.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
     bool isValidEmail(String email) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(email);
    }
    return Scaffold(
      backgroundColor: AppColors.current.white,
      body: BlocProvider(
        create: (context) => AuthBloc(
          googleLoginUseCase: getIt<GoogleLoginUseCase>(),
          loginUseCase: getIt<LoginUseCase>(),
          registerUseCase: getIt<RegisterUseCase>(),
          emailAuthService: getIt<EmailAuthService>(),
          verifyOtp: getIt<VerifyOtp>(),
          resendOtpUseCase: getIt<ResendOtpUseCase>(),
          forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
          resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
        ),
        child: Builder(
          builder: (context) {
            final bloc = context.read<AuthBloc>();
            return BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is OtpSent) {
                 context.pushNamed('otp_forgot_password', extra: bloc);
                } else if (state is AuthError) {
                  AuthToast.showError(context, state.message);
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SvgPicture.asset(
                          'assets/images/reset_password.svg',
                          fit: BoxFit.fill,
                          width: MediaQuery.sizeOf(context).width,
                        ),
                        Positioned(
                          top: 40.h,
                          left: 20.w,
                          child: GestureDetector(
                            onTap: () => context.pop(),
                            child: RtlAwareIcon(
                              child: Icon(
                                Icons.chevron_left,
                                size: 34.r,
                                color: AppColors.current.text,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: PaddingConstants.horizontalMedium,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: CustomTextFormField(
                              controller: bloc.emailForgotController,
                              hintText: AppText.enterYourEmail,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppText.required;
                                } else if (!isValidEmail(value)) {
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
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              final isLoading = state is ForgotPasswordLoading;
                              return CustomFilledButton(
                                isLoading: isLoading,
                                onPressed: () {
                                  bloc.add(
                                    ForgotPasswordEvent(
                                      bloc.emailForgotController.text,
                                    ),
                                  );
                                },
                                text: AppText.sendOtp,
                                backgroundColor: AppColors.current.primary,
                                textColor: AppColors.current.white,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
