import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';

class ChatBodyShimmer extends StatelessWidget {
  const ChatBodyShimmer({super.key});

  Widget _shimmerBox({
    required double width,
    required double height,
    required Alignment alignment,
    required BorderRadius borderRadius,
  }) {
    return Align(
      alignment: alignment,
      child: AppShimmer(
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
        borderRadius: borderRadius,
      ),
    );
  }

  Widget _buildProfileCardShimmer() {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.current.lightGray),
        ),
        child: SizedBox(
          height: 265.h,
          width: 195.w,
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: _shimmerBox(
                    width: double.infinity,
                    height: 120.h,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(height: 12.h),
                _shimmerBox(
                  width: 120.w,
                  height: 14.h,
                  alignment: Alignment.center,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 8.h),
                _shimmerBox(
                  width: 160.w,
                  height: 10.h,
                  alignment: Alignment.center,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 20.h),
                _shimmerBox(
                  width: double.infinity,
                  height: 38.h,
                  alignment: Alignment.center,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 20.h),
      physics: const NeverScrollableScrollPhysics(),
      reverse: true,
      itemBuilder: (context, index) {
        if (index == 7) return _buildProfileCardShimmer();

        final isMe = index % 3 == 0;
        return _shimmerBox(
          width: 150.w + (index * 12 % 60),
          height: 48.h,
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
            bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
          ),
        );
      },
    );
  }
}
