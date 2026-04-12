import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';

class StepSubmitted extends StatelessWidget {
  final VoidCallback onViewApplication;
  final VoidCallback onBrowseMore;

  const StepSubmitted({
    super.key,
    required this.onViewApplication,
    required this.onBrowseMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
      child: Column(
        children: [
          const Spacer(flex: 2),
          _SuccessIcon(),
          SizedBox(height: 28.h),
          Text(
            'Application Submitted!',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.current.text,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          Text(
            'Thank you! The owner will review your application and may contact you via chat.',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.current.lightText,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),
          _InfoCard(
            icon: Icons.schedule_rounded,
            iconColor: AppColors.current.gold,
            title: 'What happens next?',
            text:
                'The pet owner will review your application. If they\'re interested, they\'ll reach out to you through the chat feature.',
          ),
          const Spacer(flex: 3),
          CustomFilledButton(
            onPressed: onViewApplication,
            text: 'View My Application',
            heightFactor: 0.065,
            backgroundColor: AppColors.current.primary,
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.current.white,
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: onBrowseMore,
            child: Container(
              width: double.infinity,
              height: 50.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.current.lightBlue,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                'Browse More Pets',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.current.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.current.primary.withValues(alpha: 0.1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: 82.w,
            height: 82.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.current.primary.withValues(alpha: 0.15),
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            size: 54.w,
            color: AppColors.current.primary,
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String text;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 18.w, color: iconColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.current.text,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.current.lightText,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
