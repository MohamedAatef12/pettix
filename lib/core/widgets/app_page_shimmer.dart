import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';

class AppPageShimmer extends StatelessWidget {
  const AppPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppShimmer(width: double.infinity, height: 200),
          SizedBox(height: 24.h),
          AppShimmer(width: 150.w, height: 24.h),
          SizedBox(height: 12.h),
          const AppShimmer(width: double.infinity, height: 16),
          SizedBox(height: 8.h),
          const AppShimmer(width: double.infinity, height: 16),
          SizedBox(height: 8.h),
          AppShimmer(width: 200.w, height: 16),
          SizedBox(height: 32.h),
          Row(
            children: [
              AppShimmer.circular(radius: 20.r),
              SizedBox(width: 12.w),
              Expanded(child: AppShimmer(height: 16.h)),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              AppShimmer.circular(radius: 20.r),
              SizedBox(width: 12.w),
              Expanded(child: AppShimmer(height: 16.h)),
            ],
          ),
        ],
      ),
    );
  }
}
