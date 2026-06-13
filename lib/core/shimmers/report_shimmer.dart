import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';

class ReportShimmer extends StatelessWidget {
  const ReportShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.medium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🔹 Drag Handle Placeholder
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10.h, bottom: 16.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.current.lightGray,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          // 🔹 Title & Subtitle Shimmer placeholders
          Center(
            child: Column(
              children: [
                AppShimmer(
                  width: 100.w,
                  height: 18.h,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                SizedBox(height: 8.h),
                AppShimmer(
                  width: 240.w,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),

          // 🔹 Perfect Mirror-matched list cards
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 20.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.current.white,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: AppColors.current.lightGray.withValues(alpha: 0.4),
                      width: 1.r,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Mirroring leading CircleAvatar
                      AppShimmer.circular(radius: 18.r),
                      SizedBox(width: 12.w),
                      // Mirroring title text
                      AppShimmer(
                        width: 120.w,
                        height: 14.h,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      const Spacer(),
                      // Mirroring trailing chevron
                      AppShimmer(
                        width: 12.w,
                        height: 12.h,
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
