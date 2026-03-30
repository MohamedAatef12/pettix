import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/rtl_aware_icon.dart';

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
                  RtlAwareIcon(
                    child: SvgPicture.asset(
                      'assets/icons/privacy.svg',
                      width: 23.w,
                      height: 23.h,
                      colorFilter: ColorFilter.mode(
                        AppColors.current.text,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Text('privacy policy'.tr(), style: AppTextStyles.description),
                  const Spacer(),
                  RtlAwareIcon(
                    child: SvgPicture.asset(
                      'assets/icons/right_button.svg',
                      width: 20.w,
                      height: 20.h,
                    ),
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
                  RtlAwareIcon(
                    child: SvgPicture.asset(
                      'assets/icons/refund.svg',
                      width: 23.w,
                      height: 23.h,
                      colorFilter: ColorFilter.mode(
                        AppColors.current.text,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Text('Refund Policy'.tr(), style: AppTextStyles.description),
                  const Spacer(),
                  RtlAwareIcon(
                    child: SvgPicture.asset(
                      'assets/icons/right_button.svg',
                      width: 20.w,
                      height: 20.h,
                    ),
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
                  RtlAwareIcon(
                    child: SvgPicture.asset(
                      'assets/icons/terms.svg',
                      width: 23.w,
                      height: 23.h,
                      colorFilter: ColorFilter.mode(
                        AppColors.current.text,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Text('Terms & Conditions'.tr(), style: AppTextStyles.description),
                  const Spacer(),
                  RtlAwareIcon(
                    child: SvgPicture.asset(
                      'assets/icons/right_button.svg',
                      width: 20.w,
                      height: 20.h,
                    ),
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
