import 'package:pettix/core/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_cached_image.dart';

class AppProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final BoxFit fit;
  final Color? backgroundColor;
  final String? heroTag;

  const AppProfileImage({
    super.key,
    required this.imageUrl,
    this.radius = 30,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = radius;
    final size = effectiveRadius * 2;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? AppColors.current.blueGray,
      ),
      clipBehavior: Clip.antiAlias,
      child: AppCachedImage(
        imageUrl: imageUrl ?? '',
        height: size,
        width: size,
        fit: fit,
        backgroundColor: backgroundColor ?? AppColors.current.blueGray,
        heroTag: heroTag,
        placeholder: AppShimmer.circular(radius: radius),
        errorWidget: Image.asset(
          'assets/images/no_user.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
