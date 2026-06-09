import 'package:pettix/core/utils/date_formatter.dart';
import 'package:pettix/core/widgets/app_profile_image.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/shimmers/comments_shimmer.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';

class CommentsBody extends StatelessWidget {
  final int postId;
  final ScrollController? scrollController;
  final Widget? headerWidget;

  const CommentsBody({
    super.key,
    required this.postId,
    this.scrollController,
    this.headerWidget,
  });
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen:
          (prev, curr) =>
              prev.comments != curr.comments ||
              prev.isCommentsLoading != curr.isCommentsLoading ||
              prev.error != curr.error ||
              prev.expandedComments != curr.expandedComments ||
              prev.likedCommentId != curr.likedCommentId,
      builder: (context, state) {
        if (state.isCommentsLoading) {
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              if (headerWidget != null)
                SliverToBoxAdapter(child: headerWidget!),
              SliverToBoxAdapter(child: CommentsShimmer(hasHeader: false)),
            ],
          );
        }

        if (state.error != null && state.comments.isEmpty) {
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              if (headerWidget != null)
                SliverToBoxAdapter(child: headerWidget!),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIcon(
                        token: AppIconToken.error,
                        color: AppColors.current.red,
                        size: 50.w,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        AppText.somethingWentWrong,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.current.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        if (state.comments.isEmpty) {
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              if (headerWidget != null)
                SliverToBoxAdapter(child: headerWidget!),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text(AppText.noCommentsYet)),
              ),
            ],
          );
        }

        // Total items = header (if any) + comments
        final headerCount = headerWidget != null ? 1 : 0;

        return ListView.separated(
          controller: scrollController,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          separatorBuilder: (_, index) {
            // No separator after header
            if (headerWidget != null && index == 0) {
              return SizedBox(height: 4.h);
            }
            return SizedBox(height: 10.h);
          },
          itemCount: state.comments.length + headerCount,
          itemBuilder: (context, index) {
            if (headerWidget != null && index == 0) {
              return headerWidget!;
            }
            final commentIndex = index - headerCount;
            final comment = state.comments[commentIndex];
            return _buildCommentItem(context, comment, bloc, state);
          },
        );
      },
    );
  }

  Widget _buildCommentItem(
    BuildContext context,
    CommentEntity comment,
    HomeBloc bloc,
    HomeState state, {
    bool isReply = false,
  }) {
    final expanded = state.expandedComments[comment.id] ?? false;
    final isLiked = state.likedCommentId.contains(comment.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppProfileImage(
              imageUrl: comment.author.avatar,
              radius: isReply ? 18.r : 30.r,
            ),
            SizedBox(width: isReply ? 6.w : 10.w),
            Expanded(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.author.nameEn.toString(),
                        style: AppTextStyles.bold.copyWith(
                          fontSize: isReply ? 12.sp : 14.sp,
                        ),
                      ),
                      SizedBox(height: isReply ? 2.h : 4.h),
                      SizedBox(
                        width: 150.w,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              if (comment.parentCommentId != null) ...[
                                TextSpan(
                                  text:
                                      '@${_findParentAuthorName(comment.parentCommentId, bloc.state.comments)}: ',
                                  style: AppTextStyles.description.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                    fontSize: isReply ? 12.sp : 14.sp,
                                  ),
                                ),
                              ],
                              TextSpan(
                                text: comment.text,
                                style: AppTextStyles.description.copyWith(
                                  fontSize: isReply ? 12.sp : 14.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isReply ? 2.h : 4.h),
                      Row(
                        children: [
                          Text(
                            DateFormatter.formatRelativeTime(
                              context,
                              comment.creationDate,
                            ),
                            style: AppTextStyles.smallDescription.copyWith(
                              fontSize: isReply ? 12.sp : 12.sp,
                              color: AppColors.current.gray,
                            ),
                          ),
                          SizedBox(width: 20.w),
                          GestureDetector(
                            onTap: () {
                              bloc.add(SetReplyingToEvent(comment));
                            },
                            child: Text(
                              AppText.replyCount(
                                _getTotalRepliesCount(comment),
                              ),
                              style: AppTextStyles.smallDescription.copyWith(
                                color: AppColors.current.primary,
                                fontSize: isReply ? 10.sp : 12.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Text(
                            AppText.likesCount(
                              state.commentLikesCount[comment.id] ??
                                  comment.likes.length,
                            ),
                            style: AppTextStyles.smallDescription.copyWith(
                              color: AppColors.current.primary,
                              fontSize: isReply ? 10.sp : 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  AppIconButton(
                    token:
                        isLiked ? AppIconToken.likeActive : AppIconToken.like,
                    size: isReply ? 30.w : 34.w,
                    iconSize: isReply ? 16.w : 18.w,
                    color:
                        isLiked
                            ? AppColors.current.red
                            : AppColors.current.text.withValues(alpha: 0.72),
                    backgroundColor:
                        isLiked
                            ? AppColors.current.red.withValues(alpha: 0.1)
                            : AppColors.current.lightBlue.withValues(
                              alpha: 0.6,
                            ),
                    onTap: () {
                      if (isLiked) {
                        bloc.add(UnLikeCommentEvent(comment.id));
                      } else {
                        bloc.add(
                          AddCommentLikeEvent(
                            comment.id,
                            creatorId: comment.author.id,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
            ),
          ],
        ),
        if (comment.replies.isNotEmpty)
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: isReply ? 45.w : 50.w,
              top: 6.h,
            ),
            child: GestureDetector(
              onTap: () => bloc.add(ToggleCommentRepliesEvent(comment.id)),
              child: Text(
                expanded
                    ? AppText.hideReplies
                    : AppText.viewRepliesCount(_getTotalRepliesCount(comment)),
                style: AppTextStyles.smallDescription.copyWith(
                  color: AppColors.current.primary,
                  fontSize: isReply ? 10.sp : 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if (expanded)
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: isReply ? 0 : 50.w,
              top: 6.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  comment.replies
                      .map(
                        (reply) => _buildCommentItem(
                          context,
                          reply,
                          bloc,
                          state,
                          isReply: true,
                        ),
                      )
                      .toList(),
            ),
          ),
      ],
    );
  }

  int _getTotalRepliesCount(CommentEntity comment) {
    int count = comment.replies.length;
    for (final reply in comment.replies) {
      count += _getTotalRepliesCount(reply);
    }
    return count;
  }

  String _findParentAuthorName(int? parentId, List<CommentEntity> comments) {
    if (parentId == null) return '';
    for (final comment in comments) {
      if (comment.id == parentId) return comment.author.nameEn ?? '';
      for (final reply in comment.replies) {
        final name = _findParentAuthorName(parentId, [reply]);
        if (name.isNotEmpty) return name;
      }
    }
    return '';
  }
}
