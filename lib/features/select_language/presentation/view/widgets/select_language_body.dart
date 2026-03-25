import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/core/widgets/rtl_aware_icon.dart';
import 'dart:ui' as ui;

class SelectLanguageBody extends StatelessWidget {
  const SelectLanguageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Stack(
              children: [
                SvgPicture.asset(
                  'assets/images/on_boarding_background.svg',
                  fit: BoxFit.cover,
                  width: 766.w,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppText.selectYourLanguage, style: AppTextStyles.title),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () {
                          context.setLocale(const Locale('ar'));
                        },
                        child: Container(
                          width: 300.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: AppColors.current.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: PaddingConstants.medium,
                            child: Row(
                              children: [
                                Text(
                                  AppText.arabic,
                                  style: AppTextStyles.bold.copyWith(
                                    color: AppColors.current.lightText,
                                  ),
                                ),
                                Spacer(),
                                RtlAwareIcon(
                                  child: CircleAvatar(
                                    radius: 15.r,
                                    backgroundColor: AppColors.current.white,
                                    child: SvgPicture.asset(
                                      'assets/images/arabic.svg',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () {
                          context.setLocale(const Locale('en'));
                        },
                        child: Container(
                          width: 300.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: AppColors.current.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: PaddingConstants.medium,
                            child: Row(
                              children: [
                                Text(
                                  AppText.english,
                                  style: AppTextStyles.bold.copyWith(
                                    color: AppColors.current.lightText,
                                  ),
                                ),
                                Spacer(),
                                CircleAvatar(
                                  radius: 15.r,
                                  backgroundColor: AppColors.current.white,
                                  child: SvgPicture.asset(
                                    'assets/images/english.svg',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
      
      
                    ],
                  ),
                ),
              ],
            ),
          ),
      
        
         GestureDetector(
              onTap: () {
                context.go(AppRoutes.onBoarding);
              },
              child: Padding(
                padding: PaddingConstants.medium,
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundColor: AppColors.current.white,
                  child: SvgPicture.asset('assets/icons/right_rounded_button.svg',
                  width: 60.w,
                  height: 60.h
                  )
                ),
              ),
            ),
       
        ],
      ),
    );
  }
}
