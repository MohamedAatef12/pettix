import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';

class ChatBodyShimmer extends StatefulWidget {
  const ChatBodyShimmer({super.key});

  @override
  State<ChatBodyShimmer> createState() => _ChatBodyShimmerState();
}

class _ChatBodyShimmerState extends State<ChatBodyShimmer>
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
    _animation = Tween<double>(
      begin: 0.4,
      end: 0.7,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    required Alignment alignment,
    required BorderRadius borderRadius,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Align(
          alignment: alignment,
          child: Opacity(
            opacity: _animation.value,
            child: Container(
              width: width,
              height: height,
              margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: AppColors.current.gray,
                borderRadius: borderRadius,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCardShimmer() {
    return Center(
      child: Container(
        height: 265.h, // Increased slightly to prevent overflow
        width: 195.w,
        margin: EdgeInsets.symmetric(vertical: 20.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.current.lightGray),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use min size
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
