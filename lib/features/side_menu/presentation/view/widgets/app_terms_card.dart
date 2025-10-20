import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

class AppTermsCard extends StatelessWidget {
  const AppTermsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: PaddingConstants.large,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to Terms & Conditions page
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/privacy.svg',
                    width: 23.w,
                    height: 23.h,
                    color: AppColors.current.text,
                  ),
                  SizedBox(width: 20.w),
                  Text('privacy policy', style: AppTextStyles.description),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/icons/right_button.svg',
                    width: 20.w,
                    height: 20.h,
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () {
                // Navigate to Terms & Conditions page
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/refund.svg',
                    width: 23.w,
                    height: 23.h,
                    color: AppColors.current.text,
                  ),
                  SizedBox(width: 20.w),
                  Text('Refund Policy', style: AppTextStyles.description),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/icons/right_button.svg',
                    width: 20.w,
                    height: 20.h,
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () {
                // Navigate to Terms & Conditions page
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/terms.svg',
                    width: 23.w,
                    height: 23.h,
                    color: AppColors.current.text,
                  ),
                  SizedBox(width: 20.w),
                  Text('Terms & Conditions', style: AppTextStyles.description),
                  const Spacer(),
                  SvgPicture.asset(
                    'assets/icons/right_button.svg',
                    width: 20.w,
                    height: 20.h,
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
