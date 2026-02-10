import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/utils/custom_button.dart';
import '../../../../config/di/di.dart';
import '../../../../core/themes/app_colors.dart';
import '../bloc/adoption_bloc.dart';
import '../bloc/adoption_event.dart';
import '../bloc/adoption_state.dart';
import '../widgets/application/step1_personal_info.dart';
import '../widgets/application/step2_living_situation.dart';
import '../widgets/application/step3_pet_experience.dart';
import '../widgets/application/step4_agreements.dart';
import '../widgets/application/step5_review_application.dart';
import '../widgets/application/step6_submitted.dart';
import '../widgets/pet_application/pet_application_body.dart';

class ApplicationScreens extends StatefulWidget {
  const ApplicationScreens({super.key});

  @override
  State<ApplicationScreens> createState() => _ApplicationScreensState();
}

class _ApplicationScreensState extends State<ApplicationScreens> {
  final List<String> stepTitles = const [
    "Set up your information",
    "Living Situation",
    "Pet Experience",
    "Understanding & Agreements",
  ];

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<AdoptionBloc>()
                ..add(const ResetForm())
                ..add(FetchAdoptionOptions()),
      child: BlocConsumer<AdoptionBloc, AdoptionState>(
        listener: (context, state) {
          if (state.status == AdoptionStatus.submitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? "Error submitting")),
            );
          } else if (state.status == AdoptionStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? "Error loading options"),
              ),
            );
          } else if (state.errorMessage != null &&
              state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }

          // Handle Page Transitions
          // Step 0 is Intro (no page view index). Steps 1-5 are PageView indices 0-4.
          if (state.currentStep > 0 && _pageController.hasClients) {
            final int targetPage =
                state.currentStep - 1; // Map Step X to Index X-1
            final int? currentPage = _pageController.page?.round();

            if (currentPage != targetPage) {
              // Use jumpToPage to avoid animation gltiches and ensure correct page is shown immediately
              _pageController.jumpToPage(targetPage);
            }
          }
        },
        builder: (context, state) {
          if (state.status == AdoptionStatus.success) {
            return Scaffold(
              backgroundColor: AppColors.current.white,
              appBar: _buildAppBar(context),
              body: StepSubmitted(
                onViewApplication: () {
                  // Navigate to application details or home
                  Navigator.pop(context);
                },
                onBrowseMore: () {
                  Navigator.pop(context);
                },
              ),
            );
          }

          final bloc = context.read<AdoptionBloc>();
          // 0: Intro, 1: Personal, 2: Living, 3: Pet, 4: Agreements, 5: Review

          // If Step 0, show Intro Screen directly (no Scaffold override needed if Intro has its own structure,
          // but PetApplicationBody returns a ListView, so we wrap it in Scaffold for safety or just return it).
          // PetApplicationBody is designed to be a full screen body.
          if (state.currentStep == 0) {
            return const Scaffold(
              backgroundColor: Color(0xFFFBF4E9), // Match intro background
              body: SafeArea(child: PetApplicationBody()),
            );
          }

          // For Steps 1-5, show the Form Scaffold
          return Scaffold(
            backgroundColor: AppColors.current.white,
            appBar: _buildAppBar(context),
            body: Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  "Application for Buddy",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff3F425A),
                  ),
                ),
                // Only show progress text if NOT on review page (index 5)
                if (state.currentStep < 5)
                  Text(
                    "Step ${state.currentStep} of 4 : ${stepTitles[state.currentStep - 1]}",
                    style: const TextStyle(color: Color(0xff4A4C68)),
                  ),
                const SizedBox(height: 5),
                if (state.currentStep < 5)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0.0,
                          end: state.currentStep / 4, // 1/4, 2/4, etc.
                        ),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return LinearProgressIndicator(
                            value: value,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xff4A4C68),
                            ),
                            minHeight: 8,
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Expanded(child: _buildPageView(bloc, state)),
                _buildBottomButtons(context, state, bloc),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPageView(AdoptionBloc bloc, AdoptionState state) {
    if (state.status == AdoptionStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return PageView(
      key: const PageStorageKey('adoption_form_page_view'),
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        // Step 0 is Intro (handled separately)
        Step1PersonalInfo(), // Bloc Step 1 -> PV Index 0
        Step2LivingSituation(), // Bloc Step 2 -> PV Index 1
        Step3PetExperience(), // Bloc Step 3 -> PV Index 2
        Step4Agreements(), // Bloc Step 4 -> PV Index 3
        StepReviewApplication(), // Bloc Step 5 -> PV Index 4
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Adopt Buddy'),
      centerTitle: true,
      backgroundColor: AppColors.current.white,
      surfaceTintColor: AppColors.current.white,
      shadowColor: AppColors.current.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildBottomButtons(
    BuildContext context,
    AdoptionState state,
    AdoptionBloc bloc,
  ) {
    // Review page is index 5.
    bool isReviewPage = state.currentStep == 5;

    // If Review Page, we hide the bottom bar because the Submit button is in the body.
    if (isReviewPage) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Remove back button on Step 1 (Index 0 of PV) as requested.
          // Step 1 is state.currentStep == 1.
          if (state.currentStep > 1)
            InkWell(
              onTap: () => bloc.add(PreviousStep()),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xff5379B2), width: 1),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_circle_left_outlined,
                      color: Color(0xff5379B2),
                      size: 26,
                    ),
                    SizedBox(width: 5),
                    Center(
                      child: Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff5379B2),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (state.currentStep > 1) const SizedBox(width: 12),
          CustomFilledButton(
            onPressed: () => bloc.add(NextStep()),
            trailing: const Icon(
              Icons.arrow_circle_right_outlined,
              color: Colors.white,
              size: 26,
            ),
            hasTrailing: true,
            text: "Next",
            widthFactor:
                state.currentStep == 1
                    ? 0.8
                    : null, // keep 0.8 for first form step
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: AppColors.current.white,
            ),
            backgroundColor: const Color(0xff5379B2),
          ),
        ],
      ),
    );
  }
}
