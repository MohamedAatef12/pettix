import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pettix/core/themes/app_colors.dart';

class AppShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxShape shape;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;

  const AppShimmer({
    super.key,
    this.width,
    this.height,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.margin,
  });

  const AppShimmer.circular({super.key, required double radius})
    : width = radius * 2,
      height = radius * 2,
      shape = BoxShape.circle,
      borderRadius = null,
      margin = null;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.current.lightGray,
      highlightColor: AppColors.current.lightBlue,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: AppColors.current.lightBlue,
          shape: shape,
          borderRadius:
              borderRadius ??
              (shape == BoxShape.rectangle
                  ? BorderRadius.circular(12.r)
                  : null),
        ),
      ),
    );
  }
}
