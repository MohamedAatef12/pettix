import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';

class CommentsShimmer extends StatelessWidget {
  final bool hasHeader;
  const CommentsShimmer({super.key, this.hasHeader = false});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      separatorBuilder: (_, __) => SizedBox(height: 20.h),
      itemCount: hasHeader ? 7 : 6,
      itemBuilder: (context, index) {
        if (hasHeader && index == 0) return _buildPostHeaderShimmer();
        return _buildCommentShimmer();
      },
    );
  }

  Widget _buildPostHeaderShimmer() {
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
          SizedBox(height: 12.h),
          const AppShimmer(width: double.infinity, height: 10),
        ],
      ),
    );
  }

  Widget _buildCommentShimmer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppShimmer.circular(radius: 20.r),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppShimmer(width: 110.w, height: 11.h),
              SizedBox(height: 7.h),
              const AppShimmer(width: double.infinity, height: 11),
              SizedBox(height: 7.h),
              AppShimmer(width: 180.w, height: 11.h),
            ],
          ),
        ),
      ],
    );
  }
}
