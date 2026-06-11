import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/constants/text_styles.dart';

/// App-themed dialog with a paw icon header.
///
/// Usage:
/// ```dart
/// final confirmed = await PetDialog.show(
///   context,
///   title: AppText.logout,
///   message: AppText.logoutDesc,
///   confirmLabel: AppText.logOut,
///   confirmColor: AppColors.current.red,
///   iconColor: AppColors.current.red,
/// );
/// if (confirmed == true) { ... }
/// ```
class PetDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Color? confirmColor;
  final Color? iconColor;
  final IconData icon;

  const PetDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.cancelLabel = 'Cancel',
    this.confirmColor,
    this.iconColor,
    this.icon = Icons.pets_rounded,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    String cancelLabel = 'Cancel',
    Color? confirmColor,
    Color? iconColor,
    IconData icon = Icons.pets_rounded,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => PetDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        confirmColor: confirmColor,
        iconColor: iconColor,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.current.primary;
    final effectiveConfirmColor = confirmColor ?? AppColors.current.primary;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon header ────────────────────────────────────────
            SizedBox(height: 28.h),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                ),
                Icon(
                  icon,
                  size: 30.w,
                  color: effectiveIconColor,
                ),
              ],
            ),
            SizedBox(height: 18.h),

            // ── Title ──────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.bold.copyWith(
                  fontSize: 18.sp,
                  color: AppColors.current.text,
                ),
              ),
            ),
            SizedBox(height: 10.h),

            // ── Message ────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.current.midGray,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 26.h),

            // ── Divider + Buttons ──────────────────────────────────
            Divider(
              height: 1,
              color: AppColors.current.lightGray,
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  // Cancel
                  Expanded(
                    child: _DialogButton(
                      label: cancelLabel,
                      textColor: AppColors.current.midGray,
                      onTap: () => Navigator.of(context).pop(false),
                      isLeft: true,
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    color: AppColors.current.lightGray,
                  ),
                  // Confirm
                  Expanded(
                    child: _DialogButton(
                      label: confirmLabel,
                      textColor: effectiveConfirmColor,
                      onTap: () => Navigator.of(context).pop(true),
                      isLeft: false,
                      bold: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String label;
  final Color textColor;
  final VoidCallback onTap;
  final bool isLeft;
  final bool bold;

  const _DialogButton({
    required this.label,
    required this.textColor,
    required this.onTap,
    required this.isLeft,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: textColor.withValues(alpha: 0.08),
        highlightColor: textColor.withValues(alpha: 0.05),
        borderRadius: isLeft
            ? BorderRadius.only(bottomLeft: Radius.circular(24.r))
            : BorderRadius.only(bottomRight: Radius.circular(24.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: textColor,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
