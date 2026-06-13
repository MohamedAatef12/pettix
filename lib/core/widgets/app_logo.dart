import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/core/themes/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
  });

  static const path = 'assets/images/app_logo.svg';

  final double? size;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: width ?? size,
      height: height ?? size,
      fit: fit,
      colorFilter: ColorFilter.mode(
        color ?? AppColors.current.primary,
        BlendMode.srcIn,
      ),
    );
  }
}
