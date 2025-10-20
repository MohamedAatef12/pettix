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

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final PostEntity post;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// --- HEADER (User Info)
            Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundImage: NetworkImage(post.imageUrl),
                  onBackgroundImageError: (_, __) {
                    const AssetImage('assets/images/no_user.png');
                  },
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.username, style: AppTextStyles.bold),
                    Text(
                      post.date,
                      style: AppTextStyles.description.copyWith(
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
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

            /// --- POST CONTENT
            Text(post.text, style: AppTextStyles.description),
            post.imageUrl.isNotEmpty
                ? Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.network(
                  post.imageUrl,
                  width: double.infinity,
                  height: 200.h,
                  fit: BoxFit.cover,

                ),
              ),
            )
                : const SizedBox.shrink(),

            SizedBox(height: 10.h),

            /// --- ACTION ROW (Like, Comment, Share, Save)
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (prev, curr) =>
              prev.likedPostIds != curr.likedPostIds ||
                  prev.postLikesCount != curr.postLikesCount,
              builder: (context, state) {
                final homeBloc = context.read<HomeBloc>();

                final isLiked = state.likedPostIds.contains(post.id);
                final likesCount = state.postLikesCount[post.id] ?? post.likesCount;

                final isThrottled = homeBloc.throttledPostIds.contains(post.id);

                return Row(
                  children: [
                    GestureDetector(
                      onTap: isThrottled
                          ? null
                          : () {
                        if (isLiked) {
                          homeBloc.add(DeleteLikeEvent(post.id));
                        } else {
                          homeBloc.add(AddLikeEvent(post.id));
                        }
                      },
                      child: SvgPicture.asset(
                        'assets/icons/like.svg',
                        colorFilter: ColorFilter.mode(
                          isLiked
                              ? AppColors.current.red
                              : AppColors.current.text.withOpacity(0.7),
                          BlendMode.srcIn,
                        ),
                        height: 24.h,
                        width: 24.w,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      likesCount.toString(),
                      style: AppTextStyles.description,
                    ),

                    SizedBox(width: 10.w),

                    /// 💬 COMMENT BUTTON
                    GestureDetector(
                      onTap: () {
                        context.push('/comments', extra: post.id);
                      },

                      child: SvgPicture.asset('assets/icons/comment.svg'),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      post.commentsCount.toString(),
                      style: AppTextStyles.description,
                    ),

                    const Spacer(),

                    /// 📤 SHARE BUTTON
                    GestureDetector(
                      onTap: () {
                        // final link = 'http://alefak.runasp.net/posts/${post.id}';
                        // Share.shareUri(Uri.parse(link));
                      },
                      child: SvgPicture.asset('assets/icons/share.svg'),
                    ),
                    SizedBox(width: 10.w),

                    /// 💾 SAVE BUTTON
                    GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset('assets/icons/save_post.svg'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
