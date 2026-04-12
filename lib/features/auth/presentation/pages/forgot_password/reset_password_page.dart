import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/data/network/email_auth_service.dart';
import 'package:pettix/features/auth/domain/usecases/apple_login_use_case.dart';
import 'package:pettix/features/auth/domain/usecases/forgot_password.dart';
import 'package:pettix/features/auth/domain/usecases/google_login_use_case.dart';
import 'package:pettix/features/auth/domain/usecases/login_use_case.dart';
import 'package:pettix/features/auth/domain/usecases/register_usecase.dart';
import 'package:pettix/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:pettix/features/auth/domain/usecases/reset_password.dart';
import 'package:pettix/features/auth/domain/usecases/verify_otp.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/widgets/forgot_password/reset_password_body.dart';
import 'package:pettix/core/widgets/rtl_aware_icon.dart';

class ResetPassword extends StatelessWidget {
  final String email;
  final String otp;
  const ResetPassword({super.key, required this.email, required this.otp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.white,
      appBar: AppBar(
        backgroundColor: AppColors.current.white,
    centerTitle: true,
        title: Image.asset('assets/images/horizontal_logo.png'),

        leading: GestureDetector(
         onTap: (){
            Navigator.pop(context);
         },
         child: RtlAwareIcon(
           child: SvgPicture.asset('assets/icons/backButton.svg'),
         )),
        
      ),
      body: BlocProvider(
        create: (context) => AuthBloc(
          googleLoginUseCase: getIt<GoogleLoginUseCase>(),
          appleLoginUseCase: getIt<AppleLoginUseCase>(),
          loginUseCase: getIt<LoginUseCase>(),
          registerUseCase: getIt<RegisterUseCase>(),
          emailAuthService: getIt<EmailAuthService>(),
          verifyOtp: getIt<VerifyOtp>(),
          resendOtpUseCase: getIt<ResendOtpUseCase>(),
          forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
          resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
        ),
        child: ResetPasswordBody(
          email: email,
          otp: otp,
        ),
      ),
    );
  }
}
