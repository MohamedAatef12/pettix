import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

/// A single grouped card containing multiple [ProfileInfoRow] items.
/// Wrap your rows inside this to get the bordered card look.
class ProfileInfoGroup extends StatelessWidget {
  final List<ProfileInfoRow> rows;
  const ProfileInfoGroup({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.current.text.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: rows.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          indent: 52.w,
          color: AppColors.current.lightGray,
        ),
        itemBuilder: (_, i) => rows[i],
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String value;

  const ProfileInfoRow({
    super.key,
    required this.icon,
    this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.current.primary;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: color, size: 16.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.smallDescription.copyWith(
                    color: AppColors.current.midGray,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: AppTextStyles.description.copyWith(
                    color: AppColors.current.text,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
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
