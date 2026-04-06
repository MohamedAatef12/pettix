import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/themes/app_colors.dart';

class CommentsShimmer extends StatefulWidget {
  final bool hasHeader;

  const CommentsShimmer({super.key, this.hasHeader = false});

  @override
  State<CommentsShimmer> createState() => _CommentsShimmerState();
}

class _CommentsShimmerState extends State<CommentsShimmer>
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
    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(
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
            color: AppColors.current.lightGray.withOpacity(_animation.value),
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
      margin: EdgeInsets.symmetric(horizontal: 12.w),
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

          // Content lines
          _shimmerBox(width: 260.w, height: 10.h, borderRadius: 6.r),
          SizedBox(height: 6.h),
          _shimmerBox(width: 200.w, height: 10.h, borderRadius: 6.r),
          SizedBox(height: 6.h),
          _shimmerBox(width: 240.w, height: 10.h, borderRadius: 6.r),
          SizedBox(height: 14.h),

          // Image placeholder
          _shimmerBox(
            width: double.infinity,
            height: 180.h,
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
              _shimmerBox(width: 24.w, height: 24.h, borderRadius: 4.r),
              SizedBox(width: 10.w),
              _shimmerBox(width: 24.w, height: 24.h, borderRadius: 4.r),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentShimmer({bool isReply = false}) {
    final avatarRadius = isReply ? 18.r : 26.r;
    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? 50.w : 0,
        bottom: 16.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(
            width: avatarRadius * 2,
            height: avatarRadius * 2,
            shape: BoxShape.circle,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 100.w, height: 10.h, borderRadius: 6.r),
                SizedBox(height: 6.h),
                _shimmerBox(width: 200.w, height: 10.h, borderRadius: 6.r),
                SizedBox(height: 6.h),
                _shimmerBox(width: 160.w, height: 10.h, borderRadius: 6.r),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _shimmerBox(width: 40.w, height: 8.h, borderRadius: 4.r),
                    SizedBox(width: 16.w),
                    _shimmerBox(width: 50.w, height: 8.h, borderRadius: 4.r),
                    SizedBox(width: 16.w),
                    _shimmerBox(width: 40.w, height: 8.h, borderRadius: 4.r),
                  ],
                ),
              ],
            ),
          ),
          _shimmerBox(width: 20.w, height: 20.h, borderRadius: 4.r),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      children: [
        // Post card shimmer (only when used as full page)
        if (widget.hasHeader) ...[
          _buildPostCardShimmer(),
          SizedBox(height: 16.h),
        ],

        // Comment items shimmer
        _buildCommentShimmer(),
        _buildCommentShimmer(isReply: true),
        _buildCommentShimmer(),
        _buildCommentShimmer(),
        _buildCommentShimmer(isReply: true),
        _buildCommentShimmer(),
      ],
    );
  }
}
