import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_animation_tokens.dart';

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String value;
  final Widget? child;

  const ProfileInfoTile({
    super.key,
    required this.icon,
    this.iconColor,
    required this.label,
    required this.value,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 56.h),
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: ProfileAnimationTokens.cardBackground,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          _IconBox(icon: icon, color: iconColor),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTextStyles.smallDescription.copyWith(
                    color: ProfileAnimationTokens.mutedText,
                    fontSize: 8.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                child ??
                    Text(
                      value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bold.copyWith(
                        color: ProfileAnimationTokens.titleText,
                        fontSize: 11.sp,
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTileTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;

  const ProfileTileTextField({
    super.key,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: 1,
      cursorColor: AppColors.current.primary,
      style: AppTextStyles.bold.copyWith(
        color: ProfileAnimationTokens.titleText,
        fontSize: 11.sp,
      ),
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color? color;

  const _IconBox({required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? ProfileAnimationTokens.mutedText;
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(
        color:
            color == null
                ? ProfileAnimationTokens.iconBox
                : effectiveColor.withAlpha(20),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Icon(icon, color: effectiveColor, size: 15.w),
    );
  }
}
