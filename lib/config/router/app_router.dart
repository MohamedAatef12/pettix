import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/features/auth/presentation/pages/forgot_password/forgot_password_page.dart';
import 'package:pettix/features/auth/presentation/pages/login/login_page.dart';
import 'package:pettix/features/auth/presentation/pages/register/otp_page.dart';
import 'package:pettix/features/auth/presentation/pages/forgot_password/password_reset_done_page.dart';
import 'package:pettix/features/auth/presentation/pages/register/register_page.dart';
import 'package:pettix/features/auth/presentation/pages/forgot_password/reset_password_page.dart';
import 'package:pettix/features/auth/presentation/pages/register/set_password_page.dart';
import 'package:pettix/features/auth/presentation/pages/register/verified_page.dart';
import 'package:pettix/features/bottom_bar/views/pages/bottom_bar_page.dart';
import 'package:pettix/features/chat/presentation/view/pages/chat_list_page.dart';
import 'package:pettix/features/chat/presentation/view/pages/chat_page.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/pages/add_post_page.dart';
import 'package:pettix/features/home/presentation/pages/comments_page.dart';
import 'package:pettix/features/home/presentation/pages/home_page.dart';
import 'package:pettix/features/home/presentation/pages/home_search.dart';
import 'package:pettix/features/notification/presentation/view/pages/notification_page.dart';
import 'package:pettix/features/on_boarding/presentation/view/on_boarding_screen.dart';
import 'package:pettix/features/select_language/presentation/view/select_language_screen.dart';
import 'package:pettix/features/side_menu/presentation/view/pages/side_menu_page.dart';
import 'package:pettix/features/splash/persentation/view/splash_screen.dart';

import 'routes.dart';

GoRouter appRouter() => GoRouter(
  initialLocation: AppRoutes.splash,
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
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.selectLanguage,
      name: 'select_language',
      builder: (context, state) => const SelectLanguageScreen(),
    ),
    GoRoute(
      path: AppRoutes.onBoarding,
      name: 'onboarding',
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      name: AppRouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      name: AppRouteNames.signUp,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.setPassword,
      name: AppRouteNames.setPassword,
        builder: (context, state) => const SetPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      name: AppRouteNames.otpVerification,
      builder: (context, state) => const OTPScreen(),
    ),
    GoRoute(
      path: AppRoutes.verified,
      name: AppRouteNames.verified,
      builder: (context, state) => const VerifiedPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: AppRouteNames.forgotPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      name: AppRouteNames.resetPassword,
      builder: (context, state) => const ResetPassword(),
    ),
    GoRoute(
      path: AppRoutes.passwordResetDone,
      name: AppRouteNames.passwordResetDone,
      builder: (context, state) => const PasswordResetDonePage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: AppRouteNames.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.bottomNav,
      name: AppRouteNames.bottomNav,
      builder: (context, state) => const BottomNavigationScreen(),
    ),
    GoRoute(
      path: AppRoutes.addPost,
      name: AppRouteNames.addPost,
      builder: (context, state) => const AddPostPage(),
    ),
    GoRoute(
      path: '${AppRoutes.chat}/:index',
      name: AppRouteNames.chat,
      builder: (context, state) {
        final index = int.tryParse(state.pathParameters['index'] ?? '0') ?? 0;
        return ChatPage(index: index);
      },
    ),

    GoRoute(
      path: AppRoutes.chatList,
      name: AppRouteNames.chatList,
      builder: (context, state) => const ChatListPage(),
    ),
    GoRoute(
      path: AppRoutes.comments,
      builder: (context, state) {
        final postId = state.extra as int;

        // ✅ نستخدم BlocProvider مستقل من DI أو نمرر الـ bloc الموجود من صفحة Home
        return BlocProvider(
          create: (_) => HomeBloc.fromDI()
            ..add(
              FetchPostsCommentsEvent(postId),
            ),
          child: CommentsPage(postId: postId),
        );
      },
    ),


    GoRoute(
      path: AppRoutes.homeSearch,
      name: AppRouteNames.homeSearch,
      builder: (context, state) => const HomeSearch(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      name: AppRouteNames.notifications,
      builder: (context, state) => const NotificationPage(),
    ),
    GoRoute(
      path: AppRoutes.sideMenu,
      name: AppRouteNames.sideMenu,
      builder: (context, state) => const SideMenuPage(),
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
