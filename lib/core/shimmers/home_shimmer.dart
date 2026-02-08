import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.verticalSmall,
      child: ListView.builder(
        itemCount: 3,
        itemBuilder:
            (context, index) => Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.current.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Padding(
                padding: PaddingConstants.medium,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// --- HEADER (User Info)
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundImage: AssetImage(
                            'assets/images/no_user.png',
                          ),
                          onBackgroundImageError: (_, __) {
                            const AssetImage('assets/images/no_user.png');
                          },
                        ),
                        SizedBox(width: 10.w),
                        Column(
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
                              width: 120.w,
                              height: 10.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: AppColors.current.lightGray,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        CircleAvatar(
                          radius: 20.r,
                          backgroundColor: AppColors.current.white,
                          child: SvgPicture.asset('assets/icons/more.svg'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    /// --- POST CONTENT
                    Container(
                      width: 250.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColors.current.lightGray,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      width: 270.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColors.current.lightGray,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      width: 240.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColors.current.lightGray,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SvgPicture.asset(
                      'assets/images/no_content_photo.svg',
                      width: double.infinity,
                      height: 200.h,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/like.svg',
                          height: 24.h,
                          width: 24.w,
                        ),
                        SizedBox(width: 14.w),
                        SvgPicture.asset('assets/icons/comment.svg'),
                        const Spacer(),
                        SvgPicture.asset('assets/icons/share.svg'),
                        SizedBox(width: 10.w),
                        SvgPicture.asset('assets/icons/save_post.svg'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
