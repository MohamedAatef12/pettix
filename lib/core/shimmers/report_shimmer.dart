import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/themes/app_colors.dart';

class ReportShimmer extends StatelessWidget {
  const ReportShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.medium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Title shimmer
          Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Container(
                    width: 50.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: 10.0.r),
                  child: Container(
                    width: 120.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: AppColors.current.lightGray,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          // 🔹 List of spam reasons shimmer
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 20,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) => Container(
                width: double.infinity,
                height: 16.h,
                decoration: BoxDecoration(
                  color: AppColors.current.lightGray,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
