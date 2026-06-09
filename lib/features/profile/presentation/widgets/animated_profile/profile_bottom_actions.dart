import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_animation_tokens.dart';

class ProfileBottomActions extends StatelessWidget {
  final bool isUpdating;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const ProfileBottomActions({
    super.key,
    required this.isUpdating,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 18.h),
      decoration: BoxDecoration(
        color: ProfileAnimationTokens.screenBackground.withAlpha(242),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            SizedBox(
              width: 92.w,
              height: 46.h,
              child: CustomFilledButton(
                text: AppText.cancel,
                onPressed: isUpdating ? null : onCancel,
                widthFactor: null,
                heightFactor: null,
                backgroundColor: AppColors.current.white,
                textColor: ProfileAnimationTokens.titleText,
                borderRadius: 8.r,
                textStyle: AppTextStyles.bold.copyWith(
                  color: ProfileAnimationTokens.titleText,
                  fontSize: 11.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: SizedBox(
                height: 46.h,
                child: CustomFilledButton(
                  text: AppText.saveChanges,
                  onPressed: isUpdating ? null : onSubmit,
                  widthFactor: null,
                  heightFactor: null,
                  backgroundColor: AppColors.current.primary,
                  textColor: AppColors.current.white,
                  borderRadius: 8.r,
                  isLoading: isUpdating,
                  textStyle: AppTextStyles.bold.copyWith(
                    color: AppColors.current.white,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
