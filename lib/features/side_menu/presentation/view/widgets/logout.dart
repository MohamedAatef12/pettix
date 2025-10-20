import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

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
                    'assets/icons/logout_right.svg',
                    width: 23.w,
                    height: 23.h,
                    color: AppColors.current.red,
                  ),
                  SizedBox(width: 20.w),
                  Text('Log out', style: AppTextStyles.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
