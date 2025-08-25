import 'package:go_router/go_router.dart';
import 'package:pettix/features/auth/presentation/pages/login_page.dart';

import 'routes.dart';

GoRouter appRouter() => GoRouter(
  initialLocation: AppRoutes.login,
  // redirect: (context, state) async {
  //   final isSignedUp = await AuthService.hasSignedUp();
  //   final isLoggedIn = await AuthService.checkAuth();
  //
  //   final goingToLogin = state.uri.toString() == AppRoutes.login;
  //   final goingToSignUp = state.uri.toString() == AppRoutes.signUp;
  //
  //   if (!isSignedUp && !goingToSignUp) {
  //     return AppRoutes.signUp;
  //   }
  //
  //   if (isSignedUp && !isLoggedIn && !goingToLogin) {
  //     return AppRoutes.login;
  //   }
  //
  //   if (isLoggedIn && (goingToLogin || goingToSignUp)) {
  //     return AppRoutes.home;
  //   }
  //
  //   return null;
  // },
  routes: <RouteBase>[
    // GoRoute(
    //   path: '/',
    //   name: 'splash',
    //   builder: (context, state) => const SplashScreen(),
    // ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRouteNames.login,
      builder: (context, state) => const LoginPage(),
      // builder:
      //     (context, state) => BlocProvider(
      //   create:
      //       (context) =>
      //       AuthBloc(getIt<LoginUseCase>(), getIt<SignUpUseCase>()),
      //   child: const LoginPage(),
      // ),
    ),
    // GoRoute(
    //   path: AppRoutes.signUp,
    //   name: AppRouteNames.signUp,
    //   builder:
    //       (context, state) => BlocProvider(
    //     create:
    //         (context) =>
    //         AuthBloc(getIt<LoginUseCase>(), getIt<SignUpUseCase>()),
    //     child: const SignUpPage(),
    //   ),
    // GoRoute(
    //   path: AppRoutes.home,
    //   name: AppRouteNames.home,
    //   // builder: (context, state) => const HomePage(),
    // ),
  ],
);
