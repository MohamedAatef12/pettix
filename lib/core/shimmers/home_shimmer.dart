import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/themes/app_colors.dart';
class HomeShimmer extends StatefulWidget {
  const HomeShimmer({super.key,});
  @override
  State<HomeShimmer> createState() => _HomeShimmerState();
}

class _HomeShimmerState extends State<HomeShimmer>
  with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
  super.initState();
  _controller = AnimationController(
  vsync: this,
  duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);
  _animation = Tween<double>(begin: 0.4, end: 0.7).animate(
  CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  );
  }

  @override
  void dispose() {
  _controller.dispose();
  super.dispose();
  }
Widget _shimmerBox({
  required double width,
  required double height,
  double? borderRadius,
  BoxShape shape = BoxShape.rectangle,
}) {
  return AnimatedBuilder(
    animation: _animation,
    builder: (context, child) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.current.lightGray,
          borderRadius: shape == BoxShape.rectangle
              ? BorderRadius.circular(borderRadius ?? 8.r)
              : null,
          shape: shape,
        ),
      );
    },
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
        // Author row
        Row(
          children: [
            _shimmerBox(width: 54.r, height: 54.r, shape: BoxShape.circle),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 120.w, height: 12.h, borderRadius: 6.r),
                SizedBox(height: 6.h),
                _shimmerBox(width: 80.w, height: 10.h, borderRadius: 6.r),
              ],
            ),
          ],
        ),
        SizedBox(height: 14.h),
        _shimmerBox(width: 260.w, height: 10.h, borderRadius: 6.r),
        SizedBox(height: 6.h),
        _shimmerBox(width: 200.w, height: 10.h, borderRadius: 6.r),
        SizedBox(height: 6.h),
        _shimmerBox(width: 240.w, height: 10.h, borderRadius: 6.r),
        SizedBox(height: 14.h),

        // Image placeholder
        _shimmerBox(
          width: double.infinity,
          height: 200.h,
          borderRadius: 15.r,
        ),
        SizedBox(height: 14.h),

        // Action row
        Row(
          children: [
            _shimmerBox(width: 24.w, height: 24.h, borderRadius: 4.r),
            SizedBox(width: 6.w),
            _shimmerBox(width: 20.w, height: 10.h, borderRadius: 4.r),
            SizedBox(width: 16.w),
            _shimmerBox(width: 24.w, height: 24.h, borderRadius: 4.r),
            SizedBox(width: 6.w),
            _shimmerBox(width: 20.w, height: 10.h, borderRadius: 4.r),
            const Spacer(),
            // _shimmerBox(width: 24.w, height: 24.h, borderRadius: 4.r),
            // SizedBox(width: 10.w),
            _shimmerBox(width: 24.w, height: 24.h, borderRadius: 4.r),
          ],
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: PaddingConstants.horizontalSmall,
      children: [
          _buildPostCardShimmer(),
          SizedBox(height: 16.h),
          _buildPostCardShimmer(),
      ],
    );
  }
}
