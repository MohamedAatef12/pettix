import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';

class OnboardingStepper extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const OnboardingStepper({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin:  EdgeInsets.symmetric(horizontal: 1.w),
          width: isActive ? 28.w : 8.w, // active dot is stretched
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.current.primary
                : AppColors.current.lightText.withOpacity(0.4),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}



