import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

class AppSettingsCard extends StatelessWidget {
  const AppSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current locale from context
    final bool isArabic = context.locale.languageCode == 'ar';

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
            Row(
              children: [
                Image.asset(
                  'assets/icons/settings.png',
                  width: 20.w,
                  height: 20.h,
                  color: AppColors.current.text,
                ),
                SizedBox(width: 20.w),
                Text(
                  'Settings'.tr(),
                  style: AppTextStyles.description,
                ),
                const Spacer(),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(isArabic ? -1.0 : 1.0, 1.0),
                  child: SvgPicture.asset(
                    'assets/icons/right_button.svg',
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/languages.svg',
                  width: 23.w,
                  height: 23.h,
                  color: AppColors.current.text,
                ),
                SizedBox(width: 20.w),
                Text(
                  'Language'.tr(),
                  style: AppTextStyles.description,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Toggle between English and Arabic
                    final newLocale = isArabic 
                        ? const Locale('en') 
                        : const Locale('ar');
                    context.setLocale(newLocale);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 70.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: AppColors.current.lightGray,
                    ),
                    child: Stack(
                      children: [
                        // Sliding circle background
                        AnimatedAlign(
                          alignment: isArabic
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            width: 45.w,
                            height: 30.h,

                            decoration: BoxDecoration(
                              color: AppColors.current.green,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              isArabic ? 'ع' : 'EN',
                              style: AppTextStyles.description.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
