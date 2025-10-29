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
  const CommentsBody({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    return
     Column(
        children: [
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (prev, curr) =>
              prev.comments != curr.comments ||
                  prev.isCommentsLoading != curr.isCommentsLoading ||
                  prev.error != curr.error,
              builder: (context, state) {
                if (state.isCommentsLoading) {
                  return Center(child: CommentsShimmer());
                }

                if (state.error != null) {
                  return Center(child: Text(state.error!));
                }

                if (state.comments.isEmpty) {
                  return const Center(child: Text('No comments yet.'));
                }

                return ListView.separated(
                  padding: PaddingConstants.medium,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemCount: state.comments.length,
                  itemBuilder: (context, index) {
                    final comment = state.comments[index];
                    return _buildCommentItem(comment);
                  },
                );
              },
            ),
          ),
        ],
     );

  }

  Widget _buildCommentItem(CommentEntity comment) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundImage: const AssetImage('assets/images/profile_photo.png'),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${comment.author.id}', style: AppTextStyles.bold),
              SizedBox(height: 4.h),
              Text(comment.text, style: AppTextStyles.description),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Text(
                    DateFormat('hh:mm a').format(
                      DateTime.parse(comment.creationDate)),
                    style: AppTextStyles.smallDescription
                        .copyWith(color: AppColors.current.gray),
                  ),
                  SizedBox(width: 20.w),
                  Text(
                    '2 Likes',
                    style: AppTextStyles.smallDescription
                        .copyWith(color: AppColors.current.gray),
                  ),
                  SizedBox(width: 20.w),
                  GestureDetector(
                    onTap: (){},
                    child: Text(
                      '1 Reply',
                      style: AppTextStyles.smallDescription
                          .copyWith(color: AppColors.current.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: (){},
          child: SvgPicture.asset('assets/icons/like.svg'),
        )
      ],
    );
  }
  }
