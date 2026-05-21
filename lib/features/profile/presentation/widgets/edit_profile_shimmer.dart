import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';

class EditProfileShimmer extends StatelessWidget {
  const EditProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _EditTopBarShimmer(),
        Expanded(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                // Avatar
                Center(child: AppShimmer.circular(radius: 46.r)),
                SizedBox(height: 32.h),

                // "PERSONAL INFO" section
                AppShimmer(
                  width: 90.w,
                  height: 11.h,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                SizedBox(height: 10.h),
                AppShimmer(
                  width: double.infinity,
                  height: 52.h,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                SizedBox(height: 12.h),
                AppShimmer(
                  width: double.infinity,
                  height: 52.h,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                SizedBox(height: 24.h),

                // "DETAILS" section
                AppShimmer(
                  width: 60.w,
                  height: 11.h,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                SizedBox(height: 10.h),
                AppShimmer(
                  width: double.infinity,
                  height: 52.h,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                SizedBox(height: 12.h),

                // Gender dropdown
                AppShimmer(
                  width: double.infinity,
                  height: 52.h,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                SizedBox(height: 12.h),

                // Address field (2 lines tall)
                AppShimmer(
                  width: double.infinity,
                  height: 80.h,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                SizedBox(height: 32.h),

                // Save button
                AppShimmer(
                  width: double.infinity,
                  height: 52.h,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EditTopBarShimmer extends StatelessWidget {
  const _EditTopBarShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      child: Row(
        children: [
          AppShimmer(
            width: 32.w,
            height: 32.h,
            borderRadius: BorderRadius.circular(8.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: AppShimmer(
              height: 18.h,
              borderRadius: BorderRadius.circular(9.r),
            ),
          ),
          SizedBox(width: 12.w),
          AppShimmer(
            width: 44.w,
            height: 18.h,
            borderRadius: BorderRadius.circular(9.r),
          ),
        ],
      ),
    );
  }
}
