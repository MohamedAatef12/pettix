import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/rtl_aware_icon.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.white,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              SvgPicture.asset(
                'assets/images/reset_password.svg',
                fit: BoxFit.fill,
                width: MediaQuery.sizeOf(context).width,
              ),
              Positioned(
                top: 40.h,
                left: 20.w,
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: RtlAwareIcon(
                    child: Icon(
                      Icons.chevron_left,
                      size: 34.r,
                      color: AppColors.current.text,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Text(AppText.checkYourEmail, style: AppTextStyles.title),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppText.didntReceiveCode,
                style: AppTextStyles.description.copyWith(
                  color: AppColors.current.gray,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  AppText.resend,
                  style: AppTextStyles.description.copyWith(
                    color: AppColors.current.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
