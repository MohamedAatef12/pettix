import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';

class ChatListShimmer extends StatelessWidget {
  const ChatListShimmer({super.key});

  Widget _shimmerBox({
    required double width,
    required double height,
    double? borderRadius,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return AppShimmer(
      width: width,
      height: height,
      shape: shape,
      borderRadius:
          shape == BoxShape.rectangle
              ? BorderRadius.circular(borderRadius ?? 8.r)
              : null,
    );
  }

  Widget _buildConversationCardShimmer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          // Avatar
          _shimmerBox(width: 64.r, height: 64.r, shape: BoxShape.circle),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shimmerBox(width: 140.w, height: 14.h, borderRadius: 6.r),
                    _shimmerBox(width: 40.w, height: 10.h, borderRadius: 4.r),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    _shimmerBox(width: 180.w, height: 12.h, borderRadius: 6.r),
                    const Spacer(),
                    _shimmerBox(
                      width: 10.r,
                      height: 10.r,
                      shape: BoxShape.circle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) => _buildConversationCardShimmer(),
    );
  }
}
