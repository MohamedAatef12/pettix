import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_logo.dart';
import 'package:pettix/features/auth/presentation/widgets/register/register_form.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

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
            Text(AppText.signUp, style: AppTextStyles.title),

            Text(
              AppText.createAccountToContinue,
              style: AppTextStyles.smallDescription,
            ),
            SizedBox(height: 50.h),
            RegisterForm(),
          ],
        ),
      ),
    );
  }
}
