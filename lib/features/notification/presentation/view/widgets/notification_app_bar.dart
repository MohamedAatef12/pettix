import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/rtl_aware_icon.dart';

class NotificationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NotificationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10.h, bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.current.lightBlue.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: RtlAwareIcon(
                  child: SvgPicture.asset(
                    'assets/icons/backButton.svg',
                    width: 24.w,
                    height: 24.h,
                    colorFilter: ColorFilter.mode(
                      AppColors.current.text,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                AppText.notificationsText,
                textAlign: TextAlign.center,
                style: AppTextStyles.bold.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.current.text,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(width: 40), // Balance the back button
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70.h);
}
