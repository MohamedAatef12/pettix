import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: PaddingConstants.horizontalSmall,
      children: [
        _buildPostCardShimmer(),
        SizedBox(height: 16.h),
        _buildPostCardShimmer(),
      ],
    );
  }

  Widget _buildPostCardShimmer() {
    return Container(
      width: double.infinity,
      padding: PaddingConstants.medium,
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppShimmer.circular(radius: 27.r),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmer(width: 120.w, height: 12.h),
                  SizedBox(height: 6.h),
                  AppShimmer(width: 80.w, height: 10.h),
                ],
              ),
            ],
          ),
          SizedBox(height: 14.h),
          const AppShimmer(width: double.infinity, height: 10),
          SizedBox(height: 6.h),
          AppShimmer(width: 200.w, height: 10.h),
          SizedBox(height: 14.h),
          AppShimmer(width: double.infinity, height: 200.h, borderRadius: BorderRadius.circular(15.r)),
          SizedBox(height: 14.h),
          Row(
            children: [
              AppShimmer(width: 24.w, height: 24.h),
              SizedBox(width: 16.w),
              AppShimmer(width: 24.w, height: 24.h),
              const Spacer(),
              AppShimmer(width: 24.w, height: 24.h),
            ],
          ),
        ],
      ),
    );
  }
}
