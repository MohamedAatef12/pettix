import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import '../../features/home/domain/entities/author_entity.dart';
import '../../features/home/domain/entities/post_entity.dart';
import '../../features/home/presentation/blocs/home_bloc.dart';
import '../../features/home/presentation/pages/comments_page.dart';
import 'routes.dart';

import '../../features/adoption/presentation/view/application_view.dart';
import '../../features/notification/presentation/view/pages/notification_page.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_event.dart';
import '../../features/profile/presentation/view/edit_profile_screen.dart';
import '../../features/profile/presentation/view/profile_screen.dart';
import '../../features/profile/presentation/view/user_profile_screen.dart';
import '../../features/profile/presentation/view/settings_screen.dart';
import '../../features/help_support/presentation/view/help_support_page.dart';
import '../../features/help_support/presentation/view/faq_page.dart';
import '../../features/help_support/presentation/view/contact_support_page.dart';
import '../../features/help_support/presentation/view/report_problem_page.dart';
import '../../features/help_support/presentation/view/send_feedback_page.dart';
import '../../features/help_support/presentation/bloc/contact_support_bloc.dart';
import '../../features/help_support/presentation/bloc/feedback_bloc.dart';
import '../../features/help_support/presentation/bloc/problem_report_bloc.dart';
import '../../features/help_support/domain/repositories/help_support_repository.dart';
import '../../features/help_support/domain/usecases/submit_contact_support_usecase.dart';
import '../../features/help_support/domain/usecases/submit_problem_report_usecase.dart';
import '../../features/legal/presentation/view/legal_page.dart';
import '../../features/legal/presentation/view/about_pettix_page.dart';
import '../../features/legal/presentation/view/legal_content_page.dart';
import '../../features/my_pets/presentation/bloc/my_pets_bloc.dart';
import '../../features/my_pets/presentation/bloc/my_pets_event.dart';
import '../../features/my_pets/presentation/view/add_pet_screen.dart';
import '../../features/my_pets/presentation/view/my_pets_screen.dart';
import '../../features/adoption_history/presentation/bloc/adoption_history_bloc.dart';
import '../../features/adoption_history/presentation/bloc/adoption_history_event.dart';
import '../../features/adoption_history/presentation/view/adoption_history_screen.dart';
import '../../features/adoption_history/presentation/view/adoption_form_detail_screen.dart';
import '../../features/adoption_history/domain/entities/adoption_form_entity.dart';
import '../../features/auth/presentation/pages/forgot_password/password_reset_done_page.dart';
import '../../features/auth/presentation/pages/forgot_password/reset_password_page.dart';
import '../../features/adoption/presentation/view/adoption_screen.dart';
import '../../features/adoption/presentation/view/pet_profile_screen.dart';
import '../../features/adoption/presentation/bloc/adoption_browse_bloc.dart';
import '../../features/my_pets/domain/entities/pet_entity.dart';
import '../../features/auth/presentation/pages/forgot_password/forgot_password_page.dart';
import '../../features/auth/presentation/pages/forgot_password/otp_forgot_password_page.dart';
import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/register/otp_page.dart';
import '../../features/auth/presentation/pages/register/register_page.dart';
import '../../features/auth/presentation/pages/register/set_password_page.dart';
import '../../features/auth/presentation/pages/register/verified_page.dart';
import '../../features/bottom_bar/views/pages/bottom_bar_page.dart';
import '../../features/chat/presentation/view/pages/chat_list_page.dart';
import '../../features/chat/presentation/view/pages/chat_page.dart';
import '../../features/home/presentation/pages/add_post_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/home_search.dart';
import '../../features/home/presentation/pages/saved_posts_page.dart';
import '../../features/home/presentation/pages/user_posts_page.dart';
import '../../features/on_boarding/presentation/view/on_boarding_screen.dart';
import '../../features/select_language/presentation/view/select_language_screen.dart';
import '../../features/splash/persentation/view/splash_screen.dart';

import 'package:flutter/material.dart';

// ── Transition Helper ────────────────────────────────────────────────────────

final rootNavigatorKey = GlobalKey<NavigatorState>();

CustomTransitionPage<T> _customTransition<T>({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.02, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

final List<RouteBase> _coreRoutes = [
  GoRoute(
    path: AppRoutes.splash,
    name: AppRouteNames.splash,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const SplashScreen()),
  ),
  GoRoute(
    path: AppRoutes.selectLanguage,
    name: AppRouteNames.selectLanguage,
    pageBuilder:
        (context, state) => _customTransition(
          state: state,
          child: const SelectLanguageScreen(),
        ),
  ),
  GoRoute(
    path: AppRoutes.onBoarding,
    name: AppRouteNames.onBoarding,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const OnBoardingScreen()),
  ),
];

final List<RouteBase> _authRoutes = [
  GoRoute(
    path: AppRoutes.login,
    name: AppRouteNames.login,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const LoginScreen()),
  ),
  GoRoute(
    path: AppRoutes.signUp,
    name: AppRouteNames.signUp,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const RegisterScreen()),
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
    path: AppRoutes.otpForgotPassword,
    name: AppRouteNames.otpForgotPassword,
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
];

final List<RouteBase> _homeRoutes = [
  GoRoute(
    path: AppRoutes.bottomNav,
    name: AppRouteNames.bottomNav,
    pageBuilder:
        (context, state) => _customTransition(
          state: state,
          child: BottomNavigationScreen(
            initialTab: state.extra is int ? state.extra as int : 0,
          ),
        ),
  ),
  GoRoute(
    path: AppRoutes.home,
    name: AppRouteNames.home,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const HomePage()),
  ),
  GoRoute(
    path: AppRoutes.homeSearch,
    name: AppRouteNames.homeSearch,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const HomeSearch()),
  ),
  GoRoute(
    path: AppRoutes.addPost,
    name: AppRouteNames.addPost,
    pageBuilder: (context, state) {
      HomeBloc? bloc;
      PostEntity? editingPost;

      final extra = state.extra;
      if (extra is HomeBloc) {
        bloc = extra;
      } else if (extra is Map<String, dynamic>) {
        bloc = extra['bloc'] as HomeBloc?;
        editingPost = extra['editingPost'] as PostEntity?;
      }

      return _customTransition(
        state: state,
        child: AddPostPage(bloc: bloc, editingPost: editingPost),
      );
    },
  ),
  GoRoute(
    path: AppRoutes.notifications,
    name: AppRouteNames.notifications,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const NotificationPage()),
  ),
  GoRoute(
    path: AppRoutes.comments,
    pageBuilder: (context, state) {
      final extra = state.extra;
      Widget child;
      if (extra is Map<String, dynamic>) {
        final post = extra['post'] as PostEntity;
        final bloc = extra['bloc'] as HomeBloc;
        child = BlocProvider.value(
          value: bloc,
          child: CommentsPage(postId: post.id.toString(), post: post),
        );
      } else if (extra is PostEntity) {
        child = BlocProvider(
          create: (context) => HomeBloc.fromDI(),
          child: CommentsPage(postId: extra.id.toString(), post: extra),
        );
      } else {
        final int postId =
            extra is int ? extra : int.tryParse(extra?.toString() ?? '') ?? 0;
        child = BlocProvider(
          create: (context) => HomeBloc.fromDI(),
          child: CommentsPage(
            postId: postId.toString(),
            post: PostEntity(
              id: postId,
              content: '',
              creationDate: '',
              author: const AuthorEntity(
                id: 0,
                nameAr: '',
                nameEn: '',
                avatar: '',
                email: '',
                phone: '',
                genderId: 0,
                genderName: '',
                contactTypeId: 0,
                statusId: 0,
                age: 0,
              ),
              comments: const [],
              likes: const [],
              images: const [],
              statusId: 0,
              isSaved: false,
            ),
          ),
        );
      }
      return _customTransition(state: state, child: child);
    },
  ),
  GoRoute(
    path: AppRoutes.userPosts,
    name: AppRouteNames.userPosts,
    builder: (context, state) {
      final contactId = state.extra as int? ?? 0;
      return UserPostsPage(contactId: contactId);
    },
  ),
  GoRoute(
    path: AppRoutes.savedPosts,
    name: AppRouteNames.savedPosts,
    builder: (context, state) => const SavedPostsPage(),
  ),
];

final List<RouteBase> _socialRoutes = [
  GoRoute(
    path: '${AppRoutes.chat}/:index',
    name: AppRouteNames.chat,
    pageBuilder: (context, state) {
      final index = int.tryParse(state.pathParameters['index'] ?? '0') ?? 0;
      final isUserId = state.uri.queryParameters['isUserId'] == 'true';

      String? initialName;
      String? initialAvatar;
      AdoptionFormEntity? adoptionForm;
      AdoptionHistoryBloc? adoptionHistoryBloc;

      final extra = state.extra;
      if (extra is Map<String, dynamic>) {
        initialName = extra['name'] as String?;
        initialAvatar = extra['avatar'] as String?;
        adoptionForm = extra['adoptionForm'] as AdoptionFormEntity?;
        adoptionHistoryBloc =
            extra['adoptionHistoryBloc'] as AdoptionHistoryBloc?;
      }

      return _customTransition(
        state: state,
        child: ChatPage(
          index: index,
          isUserId: isUserId,
          initialName: initialName,
          initialAvatar: initialAvatar,
          adoptionForm: adoptionForm,
          adoptionHistoryBloc: adoptionHistoryBloc,
        ),
      );
    },
  ),
  GoRoute(
    path: AppRoutes.chatList,
    name: AppRouteNames.chatList,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const ChatListPage()),
  ),
];

final List<RouteBase> _adoptionRoutes = [
  GoRoute(
    path: AppRoutes.adoption,
    name: AppRouteNames.adoption,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const AdoptionScreen()),
  ),
  GoRoute(
    path: AppRoutes.petProfile,
    name: AppRouteNames.petProfile,
    pageBuilder:
        (context, state) => _customTransition(
          state: state,
          child: BlocProvider(
            create: (_) => DI.find<AdoptionBrowseBloc>(),
            child: PetProfileScreen(pet: state.extra as PetEntity),
          ),
        ),
  ),
  GoRoute(
    path: AppRoutes.applications,
    name: AppRouteNames.applications,
    pageBuilder: (context, state) {
      final petId = state.extra as int? ?? 0;
      return _customTransition(
        state: state,
        child: ApplicationScreens(petId: petId),
      );
    },
  ),
];

final List<RouteBase> _profileRoutes = [
  GoRoute(
    path: AppRoutes.profile,
    name: AppRouteNames.profile,
    pageBuilder:
        (context, state) => _customTransition(
          state: state,
          child: BlocProvider(
            create: (_) => DI.find<ProfileBloc>(),
            child: const ProfileScreen(),
          ),
        ),
  ),
  GoRoute(
    path: AppRoutes.userProfile,
    name: AppRouteNames.userProfile,
    pageBuilder: (context, state) {
      final contactId = state.extra as int? ?? 0;
      return _customTransition(
        state: state,
        child: UserProfileScreen(contactId: contactId),
      );
    },
  ),
  GoRoute(
    path: AppRoutes.editProfile,
    name: AppRouteNames.editProfile,
    pageBuilder: (context, state) {
      final existingBloc =
          state.extra is ProfileBloc ? state.extra as ProfileBloc : null;
      Widget child;
      if (existingBloc != null) {
        child = BlocProvider.value(
          value: existingBloc,
          child: const EditProfileScreen(),
        );
      } else {
        child = BlocProvider(
          create: (_) => DI.find<ProfileBloc>()..add(FetchProfileEvent()),
          child: const EditProfileScreen(),
        );
      }
      return _customTransition(state: state, child: child);
    },
  ),
  GoRoute(
    path: AppRoutes.settings,
    name: AppRouteNames.settings,
    pageBuilder:
        (context, state) => _customTransition(
          state: state,
          child: BlocProvider(
            create:
                (_) =>
                    DI.find<ProfileBloc>()
                      ..add(LoadNotificationSettingsEvent()),
            child: const SettingsScreen(),
          ),
        ),
  ),
];

final List<RouteBase> _myPetsRoutes = [
  GoRoute(
    path: AppRoutes.myPets,
    name: AppRouteNames.myPets,
    pageBuilder:
        (context, state) => _customTransition(
          state: state,
          child: BlocProvider(
            create:
                (_) =>
                    DI.find<MyPetsBloc>()
                      ..add(const FetchUserPetsEvent())
                      ..add(const FetchPetOptionsEvent()),
            child: const MyPetsScreen(),
          ),
        ),
  ),
  GoRoute(
    path: AppRoutes.addPet,
    name: AppRouteNames.addPet,
    pageBuilder: (context, state) {
      final existingBloc =
          state.extra is MyPetsBloc ? state.extra as MyPetsBloc : null;
      Widget child;
      if (existingBloc != null) {
        child = BlocProvider.value(
          value: existingBloc,
          child: const AddPetScreen(),
        );
      } else {
        child = BlocProvider(
          create:
              (_) => DI.find<MyPetsBloc>()..add(const FetchPetOptionsEvent()),
          child: const AddPetScreen(),
        );
      }
      return _customTransition(state: state, child: child);
    },
  ),
];

final List<RouteBase> _adoptionHistoryRoutes = [
  GoRoute(
    path: AppRoutes.adoptionHistory,
    name: AppRouteNames.adoptionHistory,
    pageBuilder:
        (context, state) => _customTransition(
          state: state,
          child: BlocProvider(
            create:
                (_) =>
                    DI.find<AdoptionHistoryBloc>()
                      ..add(const FetchClientFormsEvent()),
            child: const AdoptionHistoryScreen(),
          ),
        ),
  ),
  GoRoute(
    path: AppRoutes.adoptionFormDetail,
    name: AppRouteNames.adoptionFormDetail,
    pageBuilder: (context, state) {
      final extra = state.extra as Map<String, dynamic>;
      return _customTransition(
        state: state,
        child: BlocProvider.value(
          value: extra['bloc'] as AdoptionHistoryBloc,
          child: AdoptionFormDetailScreen(
            form: extra['form'] as AdoptionFormEntity,
            isOwnerView: extra['isOwnerView'] as bool,
          ),
        ),
      );
    },
  ),
];

final List<RouteBase> _supportRoutes = [
  GoRoute(
    path: AppRoutes.helpSupport,
    name: AppRouteNames.helpSupport,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const HelpSupportPage()),
  ),
  GoRoute(
    path: AppRoutes.faq,
    name: AppRouteNames.faq,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const FaqPage()),
  ),
  GoRoute(
    path: AppRoutes.contactSupport,
    name: AppRouteNames.contactSupport,
    pageBuilder:
        (context, state) => _customTransition(
          state: state,
          child: BlocProvider(
            create:
                (_) => ContactSupportBloc(
                  SubmitContactSupportUseCase(DI.find<HelpSupportRepository>()),
                ),
            child: const ContactSupportPage(),
          ),
        ),
  ),
  GoRoute(
    path: AppRoutes.reportProblem,
    name: AppRouteNames.reportProblem,
    pageBuilder:
        (context, state) => _customTransition(
          state: state,
          child: BlocProvider(
            create:
                (_) => ProblemReportBloc(
                  SubmitProblemReportUseCase(DI.find<HelpSupportRepository>()),
                ),
            child: const ReportProblemPage(),
          ),
        ),
  ),
  GoRoute(
    path: AppRoutes.sendFeedback,
    name: AppRouteNames.sendFeedback,
    pageBuilder:
        (context, state) => _customTransition(
          state: state,
          child: BlocProvider(
            create: (_) => DI.find<FeedbackBloc>(),
            child: const SendFeedbackPage(),
          ),
        ),
  ),
];

final List<RouteBase> _legalRoutes = [
  GoRoute(
    path: AppRoutes.legal,
    name: AppRouteNames.legal,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const LegalPage()),
  ),
  GoRoute(
    path: AppRoutes.aboutPettix,
    name: AppRouteNames.aboutPettix,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const AboutPettixPage()),
  ),
  GoRoute(
    path: AppRoutes.privacyPolicy,
    name: AppRouteNames.privacyPolicy,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const PrivacyPolicyPage()),
  ),
  GoRoute(
    path: AppRoutes.termsConditions,
    name: AppRouteNames.termsConditions,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const TermsConditionsPage()),
  ),
  GoRoute(
    path: AppRoutes.refundPolicy,
    name: AppRouteNames.refundPolicy,
    pageBuilder:
        (context, state) =>
            _customTransition(state: state, child: const RefundPolicyPage()),
  ),
];

// ── App Router ──────────────────────────────────────────────────────────────

GoRouter appRouter() => GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: <RouteBase>[
    ..._coreRoutes,
    ..._authRoutes,
    ..._homeRoutes,
    ..._socialRoutes,
    ..._adoptionRoutes,
    ..._profileRoutes,
    ..._myPetsRoutes,
    ..._adoptionHistoryRoutes,
    ..._supportRoutes,
    ..._legalRoutes,
  ],
);
