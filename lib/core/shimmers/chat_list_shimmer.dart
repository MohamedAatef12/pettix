import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/themes/app_colors.dart';

class ChatListShimmer extends StatefulWidget {
  const ChatListShimmer({super.key});

  @override
  State<ChatListShimmer> createState() => _ChatListShimmerState();
}

class _ChatListShimmerState extends State<ChatListShimmer>
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
    double? borderRadius,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: AppColors.current.lightGray,
              borderRadius:
                  shape == BoxShape.rectangle
                      ? BorderRadius.circular(borderRadius ?? 8.r)
                      : null,
              shape: shape,
            ),
          ),
        );
      },
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
                    _shimmerBox(width: 10.r, height: 10.r, shape: BoxShape.circle),
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
