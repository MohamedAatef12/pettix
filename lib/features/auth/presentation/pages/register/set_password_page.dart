import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/data/network/twilio_service.dart';
import 'package:pettix/features/auth/domain/usecases/google_login_use_case.dart';
import 'package:pettix/features/auth/domain/usecases/login_use_case.dart';
import 'package:pettix/features/auth/domain/usecases/register_usecase.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/widgets/login/login_body.dart';
import 'package:pettix/features/auth/presentation/widgets/register/set_password_body.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.current.lightBlue,
        body:SafeArea(child: BlocProvider(
            create: (context)=>AuthBloc(
              googleLoginUseCase: getIt<GoogleLoginUseCase>(),
              loginUseCase: getIt<LoginUseCase>(),
              registerUseCase: getIt<RegisterUseCase>(),
              twilioService: getIt<TwilioService>(),

            ),
            child: SetPasswordBody()))
    );
  }
}
