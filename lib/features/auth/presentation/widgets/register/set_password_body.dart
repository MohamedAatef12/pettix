import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_logo.dart';
import 'package:pettix/features/auth/presentation/widgets/register/set_password_form.dart';

class SetPasswordBody extends StatelessWidget {
  const SetPasswordBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.large,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppLogo(size: 30.w),
                SizedBox(width: 8.w),
                Text(
                  'Pettix',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.current.primary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(AppText.setPassword, style: AppTextStyles.title),
            SizedBox(height: 30.h),
            SetPasswordForm(),
          ],
        ),
      ),
    );
  }
}
