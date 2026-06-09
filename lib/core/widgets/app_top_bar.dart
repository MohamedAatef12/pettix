import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

import 'package:pettix/core/widgets/app_icon_system.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String title;
  final Widget? trailing;
  final bool showBackButton;
  final VoidCallback? onBack;
  final Color? backgroundColor;
  final Color? backButtonColor;
  final TextStyle? titleStyle;
  final bool centerTitle;

  const AppTopBar({
    super.key,
    this.leading,
    required this.title,
    this.trailing,
    this.showBackButton = false,
    this.onBack,
    this.backgroundColor,
    this.backButtonColor,
    this.titleStyle,
    this.centerTitle = true,
  });

  const AppTopBar.back({
    super.key,
    required this.title,
    this.trailing,
    this.onBack,
    this.backgroundColor,
    this.backButtonColor,
    this.titleStyle,
    this.centerTitle = true,
  }) : leading = null,
       showBackButton = true;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 4.h);

  @override
  Widget build(BuildContext context) {
    final effectiveLeading =
        leading ??
        (showBackButton
            ? AppTopBarBackButton(onPressed: onBack, color: backButtonColor)
            : const SizedBox.shrink());
    final hasLeading = leading != null || showBackButton;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: centerTitle,
      leadingWidth: hasLeading ? 56.w : 0,
      leading: hasLeading ? Center(child: effectiveLeading) : null,
      title: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style:
            titleStyle ??
            AppTextStyles.appbar.copyWith(
              color: AppColors.current.text,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
      ),
      actions: [
        if (trailing != null)
          SizedBox(width: 56.w, child: Center(child: trailing))
        else if (centerTitle && hasLeading)
          SizedBox(width: 56.w),
      ],
    );
  }
}

class AppTopBarBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;

  const AppTopBarBackButton({super.key, this.onPressed, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    final isRtl =
        Directionality.maybeOf(context) == ui.TextDirection.rtl ||
        context.locale.languageCode == 'ar';
    final icon = AppIcon.raw(
      Icons.arrow_back_ios_new_rounded,
      color: color ?? AppColors.current.text,
      size: size ?? 20.sp,
      textDirection: ui.TextDirection.ltr,
    );

    return IconButton(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      padding: EdgeInsets.zero,
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      icon:
          isRtl
              ? Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.identity()..scaleByDouble(-1.0, 1.0, 1.0, 1.0),
                child: icon,
              )
              : icon,
    );
  }
}
