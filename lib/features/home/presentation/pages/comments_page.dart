import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/home/data/models/author_model.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/features/home/presentation/widgets/comments_body.dart';
import 'package:pettix/features/home/presentation/widgets/post_card.dart';

class CommentsPage extends StatefulWidget {
  final PostEntity post;
  final String? postId;

  const CommentsPage({super.key, required this.post, this.postId});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchPostsCommentsEvent(widget.post.id));
    context.read<HomeBloc>().add(SetReplyingToEvent(null));
  }

  @override
  Widget build(BuildContext context) {
    final user = DI.find<ICacheManager>().getUserData();
    final bloc = context.read<HomeBloc>();

    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      appBar: AppBar(
        backgroundColor: AppColors.current.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.current.text,
              size: 22.r,
            ),
          ),
        ),
        title: Text(
          'Comments',
          style: AppTextStyles.bold.copyWith(fontSize: 18.sp),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            color: AppColors.current.lightGray.withOpacity(0.5),
            height: 1.h,
          ),
        ),
      ),
      body: Column(
        children: [
          // Scrollable area: PostCard + Comments
          Expanded(
            child: CommentsBody(
              postId: widget.post.id,
              headerWidget: Padding(
                padding: EdgeInsets.only(bottom: 8.h, top: 4.h),
                child: PostCard(post: widget.post, isDetailView: true),
              ),
            ),
          ),

          // Comment Input - fixed at bottom
          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (prev, curr) => prev.replyingTo != curr.replyingTo,
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.current.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.replyingTo != null) ...[
                        Container(
                          margin: EdgeInsets.only(left: 45.w),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.current.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Replying to ',
                                style: AppTextStyles.description.copyWith(
                                  fontSize: 11.sp,
                                  color: AppColors.current.text.withOpacity(
                                    0.6,
                                  ),
                                ),
                              ),
                              Text(
                                state.replyingTo!.author.nameEn ?? '',
                                style: AppTextStyles.bold.copyWith(
                                  fontSize: 11.sp,
                                  color: AppColors.current.primary,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: () => bloc.add(SetReplyingToEvent(null)),
                                child: Icon(
                                  Icons.cancel,
                                  size: 16.r,
                                  color: AppColors.current.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                      ],
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20.r,
                            backgroundImage:
                                (user?.avatar != null &&
                                        user!.avatar.toString().isNotEmpty &&
                                        user.avatar.toString().startsWith(
                                          'http',
                                        ))
                                    ? NetworkImage(user.avatar.toString())
                                    : const AssetImage(
                                          'assets/images/no_user.png',
                                        )
                                        as ImageProvider,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: TextField(
                              controller: bloc.commentTextController,
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                hintStyle: AppTextStyles.description.copyWith(
                                  fontSize: 13.sp,
                                ),
                                filled: true,
                                fillColor: AppColors.current.gray.withOpacity(
                                  0.08,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 10.h,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.r),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () => _onSubmitComment(context, bloc, user),
                            child: SvgPicture.asset(
                              'assets/icons/add_comment.svg',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onSubmitComment(
    BuildContext context,
    HomeBloc bloc,
    dynamic user,
  ) async {
    final text = bloc.commentTextController.text.trim();
    if (text.isEmpty) return;

    final userResult = await bloc.getUserDataUseCase.call();
    userResult.fold(
      (failure) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failure.message))),
      (userData) {
        // When replying to someone, the parentCommentId is already handled by the entity.
        // We don't prepend the mention as it's handled by the UI display.
        final replyingTo = bloc.state.replyingTo;
        final fullText = text;

        final comment = CommentEntity(
          id: 0,
          text: fullText,
          author: AuthorModel(
            id: userData.id,
            email: userData.email,
            nameAr: '',
            nameEn: userData.userName,
            phone: userData.phone,
            genderId: userData.genderId,
            genderName: userData.gender,
            contactTypeId: userData.contactTypeId,
            statusId: userData.statusId,
            avatar: userData.avatar,
            age: userData.age,
          ),
          creationDate: DateTime.now().toIso8601String(),
          postId: widget.post.id,
          parentCommentId: replyingTo?.id,
          replies: [],
          likes: [],
          status: 1,
        );

        bloc.add(AddCommentEvent(
          comment,
          creatorId: replyingTo?.author.id ?? widget.post.author.id,
          initialCount: bloc.state.postCommentsCount[widget.post.id] ?? widget.post.totalComments,
        ));
        bloc.commentTextController.clear();
        bloc.add(SetReplyingToEvent(null));
      },
    );
  }
}
