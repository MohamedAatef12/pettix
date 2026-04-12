import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/services/notification_service.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/auth/presentation/pages/login/login_page.dart';
import 'package:pettix/features/splash/persentation/bloc/splash_event.dart';
import 'package:pettix/features/splash/persentation/bloc/splash_states.dart';
import 'package:pettix/features/splash/persentation/view/widgets/splash_body.dart';
import 'package:pettix/features/splash/persentation/bloc/splash_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc()..add(StartAnimation()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToOnBoarding) {
            context.pushReplacement(AppRoutes.selectLanguage);
          } else if (state is SplashNavigateToHome) {
            context.pushReplacement(AppRoutes.bottomNav);
            // Wait for bottomNav to fully mount before pushing the comments route.
            // addPostFrameCallback is too early — GoRouter needs a few frames to settle.
            Future.delayed(const Duration(milliseconds: 400), () {
              NotificationService.consumePendingNavigation();
            });
          } else if (state is SplashNavigateToLogin) {
            context.pushReplacement(AppRoutes.login);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.current.lightBlue,
          body: const SplashBody(),
        )
      )
    );
  }
}
