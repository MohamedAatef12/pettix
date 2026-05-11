import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header shimmer
          Container(
            height: 180.h,
            width: double.infinity,
            color: Colors.white,
            child: Stack(
              children: [
                const AppShimmer(width: double.infinity, height: double.infinity),
                Positioned(
                  bottom: -40.r,
                  left: 20.w,
                  child: AppShimmer.circular(radius: 46.r),
                ),
              ],
            ),
          ),
          SizedBox(height: 50.h),
          // Info cards shimmer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer(width: 100.w, height: 20.h),
                SizedBox(height: 12.h),
                const AppShimmer(width: double.infinity, height: 120),
                SizedBox(height: 24.h),
                AppShimmer(width: 100.w, height: 20.h),
                SizedBox(height: 12.h),
                const AppShimmer(width: double.infinity, height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
