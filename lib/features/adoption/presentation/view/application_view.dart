import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import '../../../../config/di/di.dart';
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

class ApplicationScreens extends StatelessWidget {
  final int petId;

  const ApplicationScreens({super.key, required this.petId});

  static const List<String> _stepTitles = [
    'Set up your information',
    'Living Situation',
    'Pet Experience',
    'Understanding & Agreements',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<AdoptionBloc>()
                ..add(const ResetForm())
                ..add(SetPetId(petId))
                ..add(FetchAdoptionOptions()),
      child: BlocConsumer<AdoptionBloc, AdoptionState>(
        listener: (context, state) {
          final msg = state.errorMessage;
          if (msg != null && msg.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
          }
        },
        builder: (context, state) {
          if (state.status == AdoptionStatus.success) {
            return Scaffold(
              backgroundColor: AppColors.current.white,
              appBar: _buildAppBar(context),
              body: StepSubmitted(
                onViewApplication: () => Navigator.pop(context),
                onBrowseMore: () => Navigator.pop(context),
              ),
            );
          }

          if (state.currentStep == 0) {
            return Scaffold(
              backgroundColor: AppColors.current.white,
              body: const PetApplication(),
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
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Adopt a Pet',
        style: AppTextStyles.description.copyWith(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.current.white,
      surfaceTintColor: AppColors.current.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

// ─── Step header (title + progress) ───────────────────────────────────────────

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
              'Step ${state.currentStep} of 4',
              style: AppTextStyles.smallDescription.copyWith(
                color: AppColors.current.midGray,
              ),
            ),
            SizedBoxConstants.verticalSmall,
            Text(
              ApplicationScreens._stepTitles[state.currentStep - 1],
              style: AppTextStyles.description.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBoxConstants.verticalSmall,
            _ProgressBar(step: state.currentStep),
          ] else
            Text(
              'Review Your Application',
              style: AppTextStyles.description.copyWith(
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
    if (state.status == AdoptionStatus.loading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.current.primary),
      );
    }

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
              text: 'Next',
              trailing: const Icon(
                Icons.arrow_circle_right_outlined,
                color: Colors.white,
                size: 22,
              ),
              hasTrailing: true,
              textStyle: AppTextStyles.description.copyWith(
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
        height: 50.h,
        width: 50.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.current.primary, width: 1.5),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.current.text,
          size: 18.w,
        ),
      ),
    );
  }
}
