import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});
  @override
  Widget build(BuildContext context) {
    final cache = DI.find<ICacheManager>();

  return GestureDetector(
      onTap: () async {
        cache.logout();
        await GoogleSignIn().signOut();

        if (context.mounted) {
          context.pushReplacement('/login');
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: PaddingConstants.large,
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/logout_right.svg',
                width: 23.w,
                height: 23.h,
                color: AppColors.current.red,
              ),
              SizedBox(width: 20.w),
              Text('Log out', style: AppTextStyles.description),
            ],
          ),
        ),
      ),
    );
  }
}
