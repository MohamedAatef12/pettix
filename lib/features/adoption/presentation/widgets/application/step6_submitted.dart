import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
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
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          const Spacer(),
          Icon(Icons.mark_email_read_rounded,
              size: 100.w, color: AppColors.current.primary),
          SizedBoxConstants.verticalLarge,
          Text(
            'Application Submitted!',
            style: AppTextStyles.title.copyWith(
              fontSize: 22.sp,
              color: AppColors.current.text,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBoxConstants.verticalMedium,
          Text(
            'Thank you for submitting your adoption application. The owner will review it and may contact you via chat.',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.current.lightText,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBoxConstants.verticalLarge,
          const _NextStep(
            icon: Icons.check_circle_outline_rounded,
            text:
                'The owner will review your application and may contact you via chat.',
          ),
          const Spacer(),
          CustomFilledButton(
            onPressed: onViewApplication,
            text: 'View Your Application',
            backgroundColor: AppColors.current.primary,
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.current.white,
            ),
          ),
          SizedBoxConstants.verticalSmall,
          CustomFilledButton(
            onPressed: onBrowseMore,
            text: 'Browse More Pets',
            backgroundColor: AppColors.current.lightBlue,
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.current.primary,
            ),
          ),
          SizedBoxConstants.verticalMedium,
        ],
      ),
    );
  }
}

class _NextStep extends StatelessWidget {
  final IconData icon;
  final String text;

  const _NextStep({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.current.primary, size: 20.w),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.current.lightText,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
