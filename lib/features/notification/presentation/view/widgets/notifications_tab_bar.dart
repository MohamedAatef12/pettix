import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

class NotificationsTabButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const NotificationsTabButton({
    super.key,
    required this.title,
    required this.icon,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.current.primary : AppColors.current.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: AppColors.current.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: isActive ? AppColors.current.white : AppColors.current.primary,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: AppTextStyles.bold.copyWith(
                fontSize: 14.sp,
                color: isActive ? AppColors.current.white : AppColors.current.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}