import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/shimmers/comments_shimmer.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';


class CommentsBody extends StatelessWidget {
  final int postId;
  final ScrollController scrollController;
  const CommentsBody({super.key, required this.postId, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) =>
      prev.comments != curr.comments ||
          prev.isCommentsLoading != curr.isCommentsLoading ||
          prev.error != curr.error ||
          prev.expandedComments != curr.expandedComments,
      builder: (context, state) {
        if (state.isCommentsLoading) return Center(child: CommentsShimmer());
        if (state.error != null) return Center(child: Text(state.error!));
        if (state.comments.isEmpty) return const Center(child: Text('No comments yet.'));

        return ListView.separated(
          controller: scrollController,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemCount: state.comments.length,
          itemBuilder: (context, index) {
            final comment = state.comments[index];
            return _buildCommentItem(comment, bloc, state);
          },
        );
      },
    );
  }

  Widget _buildCommentItem(CommentEntity comment, HomeBloc bloc, HomeState state,
      {bool isReply = false}) {
    final expanded = state.expandedComments[comment.id] ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: comment.author.avatar ?? '',
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: isReply ? 18.r : 30.r,
                backgroundImage: imageProvider,
                backgroundColor: AppColors.current.lightGray,
              ),
              placeholder: (context, url) => CircleAvatar(
                radius: isReply ? 18.r : 30.r,
                backgroundColor: AppColors.current.lightGray,
              ),
              errorWidget: (context, url, error) => CircleAvatar(
                radius: isReply ? 18.r : 30.r,
                backgroundImage: const AssetImage('assets/images/no_user.png'),
              ),
            ),
            SizedBox(width: isReply ? 6.w : 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comment.author.nameEn.toString(),
                      style: AppTextStyles.bold.copyWith(
                          fontSize: isReply ? 10.sp : 14.sp)),
                  SizedBox(height: isReply ? 2.h : 4.h),
                  Text(comment.text,
                      style: AppTextStyles.description.copyWith(
                          fontSize: isReply ? 10.sp : 14.sp)),
                  SizedBox(height: isReply ? 2.h : 4.h),
                  Row(
                    children: [
                      Text(
                          DateFormat('hh:mm a')
                              .format(DateTime.parse(comment.creationDate)),
                          style: AppTextStyles.smallDescription.copyWith(
                            fontSize: isReply ? 10.sp : 12.sp,
                            color: AppColors.current.gray,
                          )),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: () {
                          bloc.add(SetReplyingToEvent(comment));
                          bloc.commentTextController.text =
                          '@${comment.author.nameEn} ';
                        },
                        child: Text('Reply (${_getTotalRepliesCount(comment)})',
                            style: AppTextStyles.smallDescription.copyWith(
                              color: AppColors.current.primary,
                              fontSize: isReply ? 10.sp : 12.sp,
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (comment.replies.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(left: isReply ? 45.w : 50.w, top: 6.h),
            child: GestureDetector(
              onTap: () => bloc.add(ToggleCommentRepliesEvent(comment.id)),
              child: Text(
                expanded
                    ? 'Hide replies'
                    : 'View replies (${_getTotalRepliesCount(comment)})',
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
            padding: EdgeInsets.only(left: isReply ? 0 : 50.w, top: 6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: comment.replies
                  .map((reply) => _buildCommentItem(
                reply,
                bloc,
                state,
                isReply: true,
              ))
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
}

