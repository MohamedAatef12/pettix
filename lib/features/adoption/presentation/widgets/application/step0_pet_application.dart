import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_bloc.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_event.dart';

class PetApplication extends StatelessWidget {
  const PetApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        _HeroSection(),
        SizedBoxConstants.verticalLarge,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Ready to welcome a pet at your home?',
            style: AppTextStyles.title.copyWith(
              fontSize: 22.sp,
              color: AppColors.current.text,
            ),
          ),
        ),
        SizedBoxConstants.verticalSmall,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'To ensure the right choice, we\'ll ask you a few questions about your living situation and experience.',
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.current.lightText,
              height: 1.6,
            ),
          ),
        ),
        SizedBoxConstants.verticalLarge,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'What to Expect',
            style: AppTextStyles.bodyTitle.copyWith(
              fontSize: 16.sp,
              color: AppColors.current.text,
            ),
          ),
        ),
        SizedBoxConstants.verticalSmall,
        const _ExpectationItem(
          icon: Icons.person_outline_rounded,
          text: 'Fill in your personal information',
        ),
        const _ExpectationItem(
          icon: Icons.home_outlined,
          text: 'Describe your living situation',
        ),
        const _ExpectationItem(
          icon: Icons.pets_outlined,
          text: 'Share your pet experience',
        ),
        const _ExpectationItem(
          icon: Icons.fact_check_outlined,
          text: 'Review and submit your application',
        ),
        SizedBoxConstants.verticalLarge,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: CustomFilledButton(
            text: 'Start Application',
            onPressed: () => context.read<AdoptionBloc>().add(NextStep()),
            heightFactor: 0.06,
            backgroundColor: AppColors.current.primary,
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.current.white,
            ),
          ),
        ),
        SizedBoxConstants.verticalLarge,
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          'assets/images/adopt_animal.svg',
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.03,
          left: 10,
          child: InkWell(
            onTap: () => context.pop(),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            
            child: SizedBox(
              width: 40.w,
              height: 40.w,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.current.text,
                size: 18.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpectationItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ExpectationItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.current.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 18.w, color: AppColors.current.primary),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.current.lightText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
