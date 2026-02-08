import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DI.find<ICacheManager>().getUserData();
    return Container(
      width: double.infinity,
      height: 108.h,
      decoration: BoxDecoration(
        color: AppColors.current.blueGray,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.r,
              backgroundImage:

                       NetworkImage(user!.avatar.toString())

            ),
            SizedBox(width: 20),
            SizedBox(
                width: 120.w,
                child: Text(user.userName, style: AppTextStyles.bold)),
            Spacer(),
            SvgPicture.asset('assets/icons/right_button.svg',
              width: 18.w, height: 25.h,),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
