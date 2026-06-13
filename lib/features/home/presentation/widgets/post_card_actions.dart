import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';
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
      buildWhen:
          (prev, curr) =>
              prev.likedPostIds != curr.likedPostIds ||
              prev.savedPostIds != curr.savedPostIds ||
              prev.postLikesCount != curr.postLikesCount ||
              prev.postCommentsCount != curr.postCommentsCount,
      builder: (context, state) {
        final homeBloc = context.read<HomeBloc>();
        final commentsCount =
            state.postCommentsCount[post.id] ?? post.totalComments;
        final isLiked = state.likedPostIds.contains(post.id);
        final isSaved = state.savedPostIds.contains(post.id);
        final likesCount = state.postLikesCount[post.id] ?? post.totalLikes;

        return Row(
          children: [
            TimelineActionButton(
              token: AppIconToken.like,
              activeToken: AppIconToken.likeActive,
              active: isLiked,
              count: likesCount,
              activeColor: AppColors.current.red,
              onTap: () {
                if (isLiked) {
                  homeBloc.add(DeleteLikeEvent(post.id));
                } else {
                  homeBloc.add(
                    AddLikeEvent(post.id, creatorId: post.author.id),
                  );
                }
              },
            ),
            SizedBox(width: 10.w),
            TimelineActionButton(
              token: AppIconToken.comment,
              count: commentsCount,
              onTap: () {
                if (isDetailView) return;
                router.push(
                  AppRoutes.comments,
                  extra: {'post': post, 'bloc': context.read<HomeBloc>()},
                );
              },
            ),
            const Spacer(),
            TimelineActionButton(
              token: AppIconToken.save,
              activeToken: AppIconToken.saveActive,
              active: isSaved,
              activeColor: AppColors.current.yellow,
              onTap: () {
                if (isSaved) {
                  homeBloc.add(UnSavePostEvent(post.id));
                } else {
                  homeBloc.add(SavePostEvent(post.id));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
