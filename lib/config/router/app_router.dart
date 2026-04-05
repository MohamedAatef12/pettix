import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/adoption/presentation/view/application_view.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_event.dart';
import '../../features/profile/presentation/view/edit_profile_screen.dart';
import '../../features/profile/presentation/view/profile_screen.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import '../../features/auth/presentation/pages/forgot_password/password_reset_done_page.dart';
import '../../features/auth/presentation/pages/forgot_password/reset_password_page.dart';
import 'routes.dart';
import 'package:pettix/features/adoption/presentation/view/adoption_screen.dart';
import 'package:pettix/features/adoption/presentation/view/pet_application.dart';
import 'package:pettix/features/adoption/presentation/view/pet_profile_screen.dart';
import 'package:pettix/features/auth/presentation/pages/forgot_password/forgot_password_page.dart';
import 'package:pettix/features/auth/presentation/pages/forgot_password/otp_forgot_password_page.dart';
import 'package:pettix/features/auth/presentation/pages/login/login_page.dart';
import 'package:pettix/features/auth/presentation/pages/register/otp_page.dart';
import 'package:pettix/features/auth/presentation/pages/register/register_page.dart';
import 'package:pettix/features/auth/presentation/pages/register/set_password_page.dart';
import 'package:pettix/features/auth/presentation/pages/register/verified_page.dart';
import 'package:pettix/features/bottom_bar/views/pages/bottom_bar_page.dart';
import 'package:pettix/features/chat/presentation/view/pages/chat_list_page.dart';
import 'package:pettix/features/chat/presentation/view/pages/chat_page.dart';
import 'package:pettix/features/home/presentation/pages/add_post_page.dart';
import 'package:pettix/features/home/presentation/pages/home_page.dart';
import 'package:pettix/features/home/presentation/pages/home_search.dart';
import 'package:pettix/features/on_boarding/presentation/view/on_boarding_screen.dart';
import 'package:pettix/features/select_language/presentation/view/select_language_screen.dart';
import 'package:pettix/features/splash/persentation/view/splash_screen.dart';

GoRouter appRouter() => GoRouter(
  initialLocation: AppRoutes.splash,

  // redirect: (context, state) async {
  //   await SharedPrefsHelper.init();
  //
  //   final isFirstOpen = SharedPrefsHelper.getBool('isFirstOpen') ?? true;
  //   final isSignedUp = await AuthService.hasSignedUp();
  //   final isLoggedIn = await AuthService.checkAuth();
  //
  //   final current = state.uri.toString();
  //
  //   if (isFirstOpen && current != AppRoutes.selectLanguage) {
  //     return AppRoutes.selectLanguage;
  //   }
  //
  //   if (current == AppRoutes.onBoarding) {
  //     await SharedPrefsHelper.setBool('isFirstOpen', false);
  //   }
  //
  //   if (!isFirstOpen) {
  //     if (!isSignedUp && current != AppRoutes.signUp) return AppRoutes.signUp;
  //     if (isSignedUp && !isLoggedIn && current != AppRoutes.login) return AppRoutes.login;
  //     if (isLoggedIn && (current == AppRoutes.login || current == AppRoutes.signUp)) return AppRoutes.home;
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
      path: '/otp_forgot_password',
      name: 'otp_forgot_password',
      builder: (context, state) => const OTPForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      name: AppRouteNames.resetPassword,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Map) {
          final authBloc = extra['bloc'] as dynamic;
          final email = extra['email'] as String? ?? '';
          final otp = extra['otp'] as String? ?? '';
          if (authBloc != null) {
            return BlocProvider.value(
              value: authBloc,
              child: ResetPassword(email: email, otp: otp),
            );
          }
          return ResetPassword(email: email, otp: otp);
        }
        return const ResetPassword(email: '', otp: '');
      },
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

    // GoRoute(
    //   path: AppRoutes.comments,
    //   builder: (context, state) {
    //     final postId = state.extra as int;
    //
    //     // ✅ نستخدم BlocProvider مستقل من DI أو نمرر الـ bloc الموجود من صفحة Home
    //     return BlocProvider(
    //       create: (_) => HomeBloc.fromDI()
    //         ..add(
    //           FetchPostsCommentsEvent(postId),
    //         ),
    //       child: CommentsPage(postId: postId),
    //     );
    //   },
    // ),
    GoRoute(
      path: AppRoutes.homeSearch,
      name: AppRouteNames.homeSearch,
      builder: (context, state) => const HomeSearch(),
    ),
    GoRoute(
      path: AppRoutes.adoption,
      name: AppRouteNames.adoption,
      builder: (context, state) => const AdoptionScreen(),
    ),

    GoRoute(
      path: AppRoutes.petProfile,
      name: AppRouteNames.petProfile,
      builder: (context, state) => const PetProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.petApplication,
      name: AppRouteNames.petApplication,
      builder: (context, state) => const PetApplicationScreen(),
    ),
    GoRoute(
      path: AppRoutes.applications,
      name: AppRouteNames.applications,
      builder: (context, state) => const ApplicationScreens(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      name: AppRouteNames.profile,
      builder: (context, state) => BlocProvider(
        create: (_) => DI.find<ProfileBloc>(),
        child: const ProfileScreen(),
      ),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      name: AppRouteNames.editProfile,
      builder: (context, state) {
        final existingBloc = state.extra is ProfileBloc ? state.extra as ProfileBloc : null;
        if (existingBloc != null) {
          return BlocProvider.value(
            value: existingBloc,
            child: const EditProfileScreen(),
          );
        }
        return BlocProvider(
          create: (_) => DI.find<ProfileBloc>()..add(FetchProfileEvent()),
          child: const EditProfileScreen(),
        );
      },
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
