import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';
import 'package:pettix/main/my_app.dart';

class PostCardActions extends StatelessWidget {
  const PostCardActions({
    super.key,
    required this.post,
    required this.isDetailView,
  });

  final PostEntity post;
  final bool isDetailView;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) =>
          prev.likedPostIds != curr.likedPostIds ||
          prev.savedPostIds != curr.savedPostIds ||
          prev.postLikesCount != curr.postLikesCount ||
          prev.postCommentsCount != curr.postCommentsCount,
      builder: (context, state) {
        final homeBloc = context.read<HomeBloc>();
        final commentsCount = state.postCommentsCount[post.id] ?? post.totalComments;
        final isLiked = state.likedPostIds.contains(post.id);
        final isSaved = state.savedPostIds.contains(post.id);
        final likesCount = state.postLikesCount[post.id] ?? post.totalLikes;

        return Row(
          children: [
            GestureDetector(
              onTap: () {
                if (isLiked) {
                  homeBloc.add(DeleteLikeEvent(post.id));
                } else {
                  homeBloc.add(AddLikeEvent(post.id, creatorId: post.author.id));
                }
              },
              child: SvgPicture.asset(
                'assets/icons/like.svg',
                colorFilter: ColorFilter.mode(
                  isLiked ? AppColors.current.red : AppColors.current.text.withOpacity(0.7),
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
            GestureDetector(
              onTap: () {
                if (isDetailView) return;
                router.push(AppRoutes.comments, extra: {
                  'post': post,
                  'bloc': context.read<HomeBloc>(),
                });
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/comment.svg',
                    height: 22.h,
                    width: 22.w,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    commentsCount.toString(),
                    style: AppTextStyles.description,
                  ),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                if (isSaved) {
                  homeBloc.add(UnSavePostEvent(post.id));
                } else {
                  homeBloc.add(SavePostEvent(post.id));
                }
              },
              child: SvgPicture.asset(
                'assets/icons/save_post.svg',
                colorFilter: ColorFilter.mode(
                  isSaved ? AppColors.current.yellow : AppColors.current.text.withOpacity(0.7),
                  BlendMode.srcIn,
                ),
                height: 26.h,
                width: 26.w,
              ),
            ),
          ],
        );
      },
    );
  }
}
