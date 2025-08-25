import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: PaddingConstants.medium,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundImage: AssetImage(
                    'assets/images/profile_photo.png',
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('John Doe', style: AppTextStyles.bold),
                    Text(
                      '6 h ago',
                      style: AppTextStyles.description.copyWith(
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.current.white,
                    child: SvgPicture.asset('assets/icons/more.svg'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s', style: AppTextStyles.description,
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/icons/like.svg')),
                Text('24', style: AppTextStyles.description),
                SizedBox(width: 10.w),
                GestureDetector(
                    onTap: () {
                 context.push('/comments');
                    },
                    child: SvgPicture.asset('assets/icons/comment.svg')),
                Text('8', style: AppTextStyles.description),
                Spacer(),
                GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/icons/share.svg')),
                Text('2', style: AppTextStyles.description),
                SizedBox(width: 10.w),
                GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/icons/save_post.svg')),
              ],
            )
          ],
        ),
      ),
    );
  }
}