import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';

class ProfileHeaderTopRow extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onCancelEdit;

  const ProfileHeaderTopRow({
    super.key,
    required this.isEditing,
    required this.onCancelEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Row(
        children: [
          IconButton(
            onPressed: context.canPop() ? () => context.pop() : null,
            icon: AppIcon(
              token: AppIconToken.back,
              color: Colors.white,
              size: 20.w,
            ),
          ),
          Expanded(
            child: Text(
              'Profile',
              textAlign: TextAlign.center,
              style: AppTextStyles.bold.copyWith(
                color: Colors.white,
                fontSize: 15.sp,
              ),
            ),
          ),
          isEditing
              ? IconButton(
                onPressed: onCancelEdit,
                icon: AppIcon(
                  token: AppIconToken.close,
                  color: Colors.white,
                  size: 20.w,
                ),
              )
              : SizedBox(width: 48.w),
        ],
      ),
    );
  }
}
