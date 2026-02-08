import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/themes/app_colors.dart';

class CommentsShimmer extends StatelessWidget {
  const CommentsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      physics: NeverScrollableScrollPhysics(),
      padding:PaddingConstants.medium ,
      itemBuilder:
          (context, index) => Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundImage: AssetImage('assets/images/no_user.png'),
                    onBackgroundImageError: (_, __) {
                      const AssetImage('assets/images/no_user.png');
                    },
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.current.lightGray,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Container(
                          width: 250.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.current.lightGray,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: 160.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.current.lightGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
    );
  }
}
