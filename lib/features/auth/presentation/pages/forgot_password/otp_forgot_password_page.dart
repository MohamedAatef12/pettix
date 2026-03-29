import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/data/network/email_auth_service.dart';
import 'package:pettix/data/network/twilio_service.dart';
import 'package:pettix/features/auth/domain/usecases/google_login_use_case.dart';
import 'package:pettix/features/auth/domain/usecases/login_use_case.dart';
import 'package:pettix/features/auth/domain/usecases/register_usecase.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/widgets/login/login_body.dart';
import 'package:pettix/features/auth/presentation/pages/forgot_password/otp_forgot_password_body.dart';

class OTPForgotPasswordScreen extends StatelessWidget {
  const OTPForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = GoRouterState.of(context).extra as AuthBloc;
    return Scaffold(
        backgroundColor: AppColors.current.white,
        body:SafeArea(
          child: BlocProvider.value(
            value: authBloc,
            child: OTPForgotPasswordBody(),
          )
        )
    );
  }
}
