import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';

class ProfileCard extends StatelessWidget {
  final int index;
  const ProfileCard({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 255.h,
      width: 195.w,
      decoration: BoxDecoration(
        color:AppColors.current.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.current.lightGray,
        )
      ),
      child: Padding(
        padding: PaddingConstants.medium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/dog.png',fit: BoxFit.fill,
            width: double.infinity,
            ),
            SizedBox(height: 10.h),
            Text(
              'User $index',
              style: AppTextStyles.bold
            ),
            Text(
              'Subbran animal league Energtic and loves walks',
              style: AppTextStyles.smallDescription,
            ),
            SizedBox(height: 12.h,),
            CustomFilledButton(text: 'View Profile', onPressed: (){},
            backgroundColor: AppColors.current.primary,
            )
          ],
        ),
      ),
    );
  }
}
