import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/on_boarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:pettix/features/on_boarding/presentation/bloc/on_boarding_events.dart';
import 'package:pettix/features/on_boarding/presentation/bloc/on_boarding_states.dart';
import 'package:pettix/features/on_boarding/presentation/view/widgets/on_boarding_stepper.dart';

class OnBoardingBody extends StatelessWidget {
  OnBoardingBody({super.key});

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingBloc, OnBoardingState>(
      builder: (context, state) {
        final bloc = context.read<OnBoardingBloc>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // top content
            Expanded(
              child: Stack(
                children: [
                  SvgPicture.asset(
                    'assets/images/on_boarding_background.svg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),

                  // ✅ PageView
                  PageView.builder(
                    controller: _pageController,
                    itemCount: bloc.slides.length,
                    onPageChanged: (index) {
                      bloc.add(PageSwiped(index));
                    },
                    itemBuilder: (context, index) {
                      final slide = bloc.slides[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            slide.image,
                            fit: BoxFit.cover,
                            width: 369.w,
                            height: 369.h,
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            slide.title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.title.copyWith(
                              color: AppColors.current.lightText,
                              fontSize: 18.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            slide.desc,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bold.copyWith(
                              color: AppColors.current.lightText,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // bottom controls
            Padding(
              padding: PaddingConstants.medium,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.login),
                    child: Text(
                      'Skip',
                      style: AppTextStyles.bold.copyWith(
                        color: AppColors.current.lightText,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),

                  // ✅ Progress Stepper
                  OnboardingStepper(
                    currentPage: state.currentPage,
                    totalPages: bloc.slides.length,
                  ),

                  // Next button
                  GestureDetector(
                    onTap: () {
                      if (state.currentPage == bloc.slides.length - 1) {
                        context.go(AppRoutes.login);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        bloc.add(NextPage());
                      }
                    },
                    child: CircleAvatar(
                      radius: 30.r,
                      backgroundColor: AppColors.current.white,
                      child: SvgPicture.asset(
                        'assets/icons/right_rounded_button.svg',
                        width: 60.w,
                        height: 60.h,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

