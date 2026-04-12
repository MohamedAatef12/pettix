import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/widgets/register/set_password_body.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = GoRouterState.of(context).extra as AuthBloc;
    return Scaffold(
        backgroundColor: AppColors.current.lightBlue,
        body:SafeArea(child: BlocProvider.value(
        value: authBloc,
        child: const SetPasswordBody(),
    )
    )
    );
  }
}
