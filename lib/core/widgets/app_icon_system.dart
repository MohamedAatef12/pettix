import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

enum AppIconToken {
  like,
  likeActive,
  comment,
  save,
  saveActive,
  more,
  report,
  reportSpam,
  reportHarassment,
  reportHate,
  reportHidden,
  reportWarning,
  reportCopyright,
  reportFalse,
  reportOther,
  close,
  info,
  chevronBack,
  chevronForward,
  notification,
  search,
  photo,
  camera,
  public,
  send,
  offline,
  error,
}

class AppIcon extends StatelessWidget {
  final AppIconToken token;
  final double? size;
  final Color? color;
  final bool filled;

  const AppIcon({
    super.key,
    required this.token,
    this.size,
    this.color,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      _iconData(token, filled: filled),
      size: size ?? 20.w,
      color: color ?? AppColors.current.text,
    );
  }

  static IconData _iconData(AppIconToken token, {bool filled = false}) {
    switch (token) {
      case AppIconToken.like:
        return filled ? Iconsax.heart5 : Iconsax.heart;
      case AppIconToken.likeActive:
        return Iconsax.heart5;
      case AppIconToken.comment:
        return Iconsax.message_text;
      case AppIconToken.save:
        return filled ? Iconsax.archive_15 : Iconsax.archive_1;
      case AppIconToken.saveActive:
        return Iconsax.archive_15;
      case AppIconToken.more:
        return Iconsax.more;
      case AppIconToken.report:
        return Iconsax.flag;
      case AppIconToken.reportSpam:
        return Iconsax.sms;
      case AppIconToken.reportHarassment:
        return Iconsax.shield_cross;
      case AppIconToken.reportHate:
        return Iconsax.emoji_sad;
      case AppIconToken.reportHidden:
        return Iconsax.eye_slash;
      case AppIconToken.reportWarning:
        return Iconsax.warning_2;
      case AppIconToken.reportCopyright:
        return Iconsax.document_text;
      case AppIconToken.reportFalse:
        return Iconsax.info_circle;
      case AppIconToken.reportOther:
        return Iconsax.more_circle;
      case AppIconToken.close:
        return Iconsax.close_circle;
      case AppIconToken.info:
        return Iconsax.info_circle;
      case AppIconToken.chevronBack:
        return Iconsax.arrow_left_2;
      case AppIconToken.chevronForward:
        return Iconsax.arrow_right_3;
      case AppIconToken.notification:
        return Iconsax.notification_bing;
      case AppIconToken.search:
        return Iconsax.search_normal_1;
      case AppIconToken.photo:
        return Iconsax.gallery_add;
      case AppIconToken.camera:
        return Iconsax.camera;
      case AppIconToken.public:
        return Iconsax.global;
      case AppIconToken.send:
        return Iconsax.send_2;
      case AppIconToken.offline:
        return Iconsax.cloud_cross;
      case AppIconToken.error:
        return Iconsax.warning_2;
    }
  }
}

class AppIconButton extends StatelessWidget {
  final AppIconToken token;
  final VoidCallback? onTap;
  final double? size;
  final double? iconSize;
  final Color? color;
  final Color? backgroundColor;
  final String? tooltip;
  final bool filled;

  const AppIconButton({
    super.key,
    required this.token,
    this.onTap,
    this.size,
    this.iconSize,
    this.color,
    this.backgroundColor,
    this.tooltip,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final dimension = size ?? 36.w;
    final child = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(dimension / 2),
      child: Container(
        width: dimension,
        height: dimension,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.current.lightBlue,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AppIcon(
            token: token,
            size: iconSize ?? 18.w,
            color: color ?? AppColors.current.text,
            filled: filled,
          ),
        ),
      ),
    );

    if (tooltip == null) return child;
    return Tooltip(message: tooltip!, child: child);
  }
}

class AppIconPill extends StatelessWidget {
  final AppIconToken token;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const AppIconPill({
    super.key,
    required this.token,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color.withValues(alpha: 0.12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(token: token, size: 20.w, color: color),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTextStyles.description.copyWith(
                color: AppColors.current.text,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimelineActionButton extends StatelessWidget {
  final AppIconToken token;
  final AppIconToken? activeToken;
  final bool active;
  final int? count;
  final VoidCallback onTap;
  final Color? activeColor;

  const TimelineActionButton({
    super.key,
    required this.token,
    this.activeToken,
    this.active = false,
    this.count,
    required this.onTap,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor = activeColor ?? AppColors.current.primary;
    final iconColor =
        active ? selectedColor : AppColors.current.text.withValues(alpha: 0.72);
    final backgroundColor =
        active
            ? selectedColor.withValues(alpha: 0.1)
            : AppColors.current.lightBlue.withValues(alpha: 0.6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsetsDirectional.only(
          start: 8.w,
          end: count == null ? 8.w : 10.w,
          top: 6.h,
          bottom: 6.h,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color:
                active
                    ? selectedColor.withValues(alpha: 0.16)
                    : AppColors.current.lightGray.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(
              token: active ? activeToken ?? token : token,
              size: 20.w,
              color: iconColor,
              filled: active,
            ),
            if (count != null) ...[
              SizedBox(width: 5.w),
              Text(
                count.toString(),
                style: AppTextStyles.description.copyWith(
                  color: AppColors.current.text.withValues(alpha: 0.82),
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
