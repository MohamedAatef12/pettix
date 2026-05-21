import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 48.h),

          // Avatar — centered, mirrors ProfileHeader ring layout
          Center(child: AppShimmer.circular(radius: 52.r)),
          SizedBox(height: 16.h),

          // Name
          Center(
            child: AppShimmer(
              width: 140.w,
              height: 18.h,
              borderRadius: BorderRadius.circular(9.r),
            ),
          ),
          SizedBox(height: 6.h),

          // Email
          Center(
            child: AppShimmer(
              width: 110.w,
              height: 12.h,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          SizedBox(height: 4.h),

          // Phone
          Center(
            child: AppShimmer(
              width: 80.w,
              height: 12.h,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          SizedBox(height: 28.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "PERSONAL INFO" label
                AppShimmer(
                  width: 90.w,
                  height: 11.h,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                SizedBox(height: 8.h),
                const _ProfileInfoCardShimmer(rows: 3),
                SizedBox(height: 16.h),

                // "DETAILS" label
                AppShimmer(
                  width: 60.w,
                  height: 11.h,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                SizedBox(height: 8.h),
                const _ProfileInfoCardShimmer(rows: 3),
                SizedBox(height: 24.h),

                // "MY PETS" label
                AppShimmer(
                  width: 60.w,
                  height: 11.h,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                SizedBox(height: 8.h),
                AppShimmer(
                  width: double.infinity,
                  height: 100.h,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoCardShimmer extends StatelessWidget {
  final int rows;
  const _ProfileInfoCardShimmer({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.current.text.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < rows; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: 52.w,
                color: AppColors.current.lightGray,
              ),
            const _ProfileInfoRowShimmer(),
          ],
        ],
      ),
    );
  }
}

class _ProfileInfoRowShimmer extends StatelessWidget {
  const _ProfileInfoRowShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          AppShimmer(
            width: 32.w,
            height: 32.w,
            borderRadius: BorderRadius.circular(8.r),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppShimmer(
                width: 56.w,
                height: 10.h,
                borderRadius: BorderRadius.circular(5.r),
              ),
              SizedBox(height: 4.h),
              AppShimmer(
                width: 110.w,
                height: 14.h,
                borderRadius: BorderRadius.circular(7.r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
