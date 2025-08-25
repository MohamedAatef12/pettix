import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

class CommentsBody extends StatelessWidget {
  const CommentsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

          Column(
            children: [
              Padding(
                padding: PaddingConstants.medium, child: Row(
                  children: [
                    SizedBox(width: 10.w,),
                    CircleAvatar(
                      radius: 25.r,
                      backgroundImage: AssetImage('assets/images/profile_photo.png'),
                    ),
                    SizedBox(width: 10.w,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('John Doe', style: AppTextStyles.bold),
                        SizedBox(height: 5.h,),
                        Text('Nice Post!', style: AppTextStyles.description),
                        SizedBox(height: 5.h,),
                        Row(
                          children: [
                            Text('1 hour ago', style: AppTextStyles.smallDescription.copyWith( color: AppColors.current.gray,)),
                            SizedBox(width: 10.w,),
                            Text('3 likes', style: AppTextStyles.smallDescription.copyWith( color: AppColors.current.gray,)),
                            SizedBox(width: 10.w,),
                            Text('1 Reply', style: AppTextStyles.smallDescription.copyWith( color: AppColors.current.gray,)),
                          ],
                        ),
                          ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: (){},
                      child: SvgPicture.asset('assets/icons/like.svg')),
                  ],
                ),
              ),
              SizedBox(height: 15.h,),
              Padding(
                padding:  EdgeInsets.only(left: 50.0.r),
                child: Row(
                  children: [
                    SizedBox(width: 10.w,),
                    CircleAvatar(
                      radius: 25.r,
                      backgroundImage: AssetImage('assets/images/profile_photo.png'),
                    ),
                    SizedBox(width: 10.w,),
                    Column(
                      children: [
                        Text('Jane Smith', style: AppTextStyles.bold),
                        SizedBox(height: 5.h,),
                        Text('Great content!', style: AppTextStyles.description),
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: (){},
                        child: SvgPicture.asset('assets/icons/like.svg')),
                  ],
                ),
              ),
           ],
          )
        ],
      ),
    );
  }
}
