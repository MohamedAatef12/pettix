import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/services/app_review_service.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/auth_toast.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/features/my_pets/domain/usecases/get_user_pets_usecase.dart';
import '../../../../config/di/di.dart';
import '../../../../config/router/routes.dart';
import '../bloc/adoption_bloc.dart';
import '../bloc/adoption_event.dart';
import '../bloc/adoption_state.dart';
import '../widgets/application/step1_personal_info.dart';
import '../widgets/application/step2_living_situation.dart';
import '../widgets/application/step3_pet_experience.dart';
import '../widgets/application/step4_agreements.dart';
import '../widgets/application/step5_review_application.dart';
import '../widgets/application/step6_submitted.dart';
import '../widgets/application/step0_pet_application.dart';

import 'package:pettix/core/widgets/app_icon_system.dart';

class ApplicationScreens extends StatefulWidget {
  final int petId;

  const ApplicationScreens({super.key, required this.petId});

  static List<String> get _stepTitles => [
    AppText.setUpYourInformation,
    AppText.livingSituation,
    AppText.petExperience,
    AppText.understandingAgreements,
  ];

  @override
  State<ApplicationScreens> createState() => _ApplicationScreensState();
}

class _ApplicationScreensState extends State<ApplicationScreens> {
  late final Future<bool> _isOwnPetFuture;

  @override
  void initState() {
    super.initState();
    _isOwnPetFuture = _isOwnPet();
  }

  Future<bool> _isOwnPet() async {
    final userId = getIt<ICacheManager>().getUserData()?.id;
    if (userId == null || widget.petId <= 0) return false;

    final result = await getIt<GetUserPetsUseCase>().call(userId);
    return result.fold(
      (_) => false,
      (pets) => pets.any((pet) => pet.id == widget.petId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<AdoptionBloc>()
                ..add(const ResetForm())
                ..add(SetPetId(widget.petId))
                ..add(FetchAdoptionOptions()),
      child: FutureBuilder<bool>(
        future: _isOwnPetFuture,
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return _buildOwnPetBlocked(context);
          }

          return BlocConsumer<AdoptionBloc, AdoptionState>(
            listener: (context, state) async {
              final msg = state.errorMessage;
              if (msg != null && msg.isNotEmpty) {
                AuthToast.showError(context, msg);
              }
              if (state.status == AdoptionStatus.success) {
                await AppReviewService.requestAfterFirstAdoption(context);
              }
            },
            builder: (context, state) {
              if (state.status == AdoptionStatus.success) {
                return Scaffold(
                  backgroundColor: AppColors.current.white,
                  appBar: _buildAppBar(context),
                  body: StepSubmitted(
                    onViewApplication: () {
                      context.goNamed(AppRouteNames.adoptionHistory);
                    },
                    onBrowseMore: () {
                      context.go(AppRoutes.bottomNav, extra: 1);
                    },
                  ),
                );
              }

              if (state.currentStep == 0) {
                return Scaffold(
                  backgroundColor: AppColors.current.white,
                  body: PetApplication(),
                );
              }

              return Scaffold(
                backgroundColor: AppColors.current.white,
                appBar: _buildAppBar(context),
                body: Column(
                  children: [
                    SizedBoxConstants.verticalSmall,
                    _StepHeader(state: state),
                    SizedBoxConstants.verticalMedium,
                    Expanded(child: _StepContent(state: state)),
                    _BottomNav(state: state),
                    SizedBox(height: 30.h),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOwnPetBlocked(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.white,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.w,
                height: 72.w,
                decoration: BoxDecoration(
                  color: AppColors.current.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: AppIcon.raw(
                  Icons.pets_rounded,
                  color: AppColors.current.primary,
                  size: 34.w,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                AppText.cannotApplyOwnPet,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.current.text,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                AppText.cannotApplyOwnPetDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.current.midGray,
                  fontSize: 13.sp,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),
              CustomFilledButton(
                onPressed: () => context.pop(),
                text: AppText.done,
                backgroundColor: AppColors.current.primary,
                textStyle: TextStyle(
                  color: AppColors.current.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppTopBar.back(
      title: AppText.adoptAPet,
      backgroundColor: AppColors.current.white,
      onBack: () => Navigator.pop(context),
    );
  }
}

// ─── Step header (title + progress) ──────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  final AdoptionState state;

  const _StepHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    final isReview = state.currentStep == 5;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isReview) ...[
            Text(
              '${AppText.step} ${state.currentStep} ${AppText.of} 4',
              style: TextStyle(
                color: AppColors.current.midGray,
                fontSize: 12.sp,
              ),
            ),
            SizedBoxConstants.verticalSmall,
            Text(
              ApplicationScreens._stepTitles[state.currentStep - 1],
              style: TextStyle(
                color: AppColors.current.text,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBoxConstants.verticalSmall,
            _ProgressBar(step: state.currentStep),
          ] else
            Text(
              AppText.reviewYourApplication,
              style: TextStyle(
                color: AppColors.current.text,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int step;

  const _ProgressBar({required this.step});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.r),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: step / 4),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        builder:
            (context, value, _) => LinearProgressIndicator(
              value: value,
              backgroundColor: AppColors.current.lightGray,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.current.primary,
              ),
              minHeight: 6,
            ),
      ),
    );
  }
}

// ─── Step content via IndexedStack ────────────────────────────────────────────

class _StepContent extends StatelessWidget {
  final AdoptionState state;

  const _StepContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final index = (state.currentStep - 1).clamp(0, 4);
    return IndexedStack(
      index: index,
      children: const [
        Step1PersonalInfo(),
        Step2LivingSituation(),
        Step3PetExperience(),
        Step4Agreements(),
        StepReviewApplication(),
      ],
    );
  }
}

// ─── Bottom navigation buttons ────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final AdoptionState state;

  const _BottomNav({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.currentStep == 5) return const SizedBox.shrink();
    final bloc = context.read<AdoptionBloc>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (state.currentStep > 1) ...[
            _BackButton(onTap: () => bloc.add(PreviousStep())),
            SizedBoxConstants.horizontalSmall,
          ],
          Expanded(
            child: CustomFilledButton(
              onPressed: () => bloc.add(NextStep()),
              text: AppText.next,
              trailing: const AppIcon.raw(
                Icons.arrow_circle_right_outlined,
                color: Colors.white,
                size: 22,
              ),
              hasTrailing: true,
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.current.white,
              ),
              backgroundColor: AppColors.current.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45.h,
        width: 45.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          border: Border.all(color: AppColors.current.primary, width: 1.5),
        ),
        child: AppTopBarBackButton(onPressed: onTap, size: 18.w),
      ),
    );
  }
}
