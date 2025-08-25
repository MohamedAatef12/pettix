import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.white,
      body: Column(
        children: [
          Stack(
            children:[SvgPicture.asset(
              'assets/images/reset_password.svg',
              fit: BoxFit.fill,
              width: MediaQuery.sizeOf(context).width,
            ),
              Positioned(
                top: 40.h,
                left: 20.w,
                child: GestureDetector(
                  onTap: () {
                   context.pop();
                  },
                  child: SvgPicture.asset('assets/icons/backButton.svg'),
                ),
              ),
            ]
          ),

          Text('Check Your Email', style: AppTextStyles.title),
          SizedBox(height: 10.h,),
          Text('Enter the OTP we sent to +45472****', style: AppTextStyles.smallDescription),
         SizedBox(height: 10.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Didn’t receive link? ',style: AppTextStyles.smallDescription.copyWith(
                color: AppColors.current.gray,
              ),),
              GestureDetector(
                onTap: () {

                },
                child: Text('Resend',style: AppTextStyles.smallDescription.copyWith(
                  color: AppColors.current.primary,
                  fontWeight: FontWeight.w600,
                ),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
