import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/home/data/models/author_model.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/domain/usecases/add_comment.dart';
import 'package:pettix/features/home/domain/usecases/add_post.dart';
import 'package:pettix/features/home/domain/usecases/delete_post.dart';
import 'package:pettix/features/home/domain/usecases/dislike_post.dart';
import 'package:pettix/features/home/domain/usecases/get_comments_id.dart';
import 'package:pettix/features/home/domain/usecases/get_post_comments_count.dart';
import 'package:pettix/features/home/domain/usecases/get_posts.dart';
import 'package:pettix/features/home/domain/usecases/get_posts_likes.dart';
import 'package:pettix/features/home/domain/usecases/get_user_cached%20_data.dart';
import 'package:pettix/features/home/domain/usecases/like_post.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/features/home/presentation/widgets/comments_body.dart';

class CommentsBottomSheet {
  static void show(BuildContext context, int postId) {
    final user = DI.find<ICacheManager>().getUserData();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
       return BlocProvider(
          create: (context) =>HomeBloc(
            getPostCommentsCountUseCase: getIt<GetPostCommentsCountsUseCase>(),
            getUserDataUseCase: getIt<GetUserDataUseCase>(),
            getCommentsIdUseCase: getIt<GetPostCommentsUseCase>(),
            getPostsLikesUseCase: getIt<GetPostLikesUseCase>(),
            getPostsUseCase: getIt<GetPostsUseCase>(),
              addPostUseCase: getIt<AddPostUseCase>(),
            addCommentUseCase: getIt<AddCommentUseCase>(),
              unlikePostUseCase: getIt<UnLikePostUseCase>(),
            likePostUseCase: getIt<LikePostUseCase>(),
            deletePostUseCase: getIt<DeletePostUseCase>(),


          )..add(FetchPostsCommentsEvent(postId))
           ..add(SetReplyingToEvent(null))..add(UpdatePostCommentsCountEvent(postId))..add(GetPostCommentsCountsEvent(postId)),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.95,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
             final bloc = context.read<HomeBloc>();
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.current.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                ),
                child: Column(
                  children: [
                    // Handle bar
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Container(
                        width: 50.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    // AppBar imitation
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(Icons.chevron_left, size: 35.r),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Comments',
                            style: AppTextStyles.bold.copyWith(fontSize: 20.sp),
                          ),
                        ],
                      ),
                    ),
                    // Comments list
                    Expanded(
                      child: CommentsBody(
                        postId: postId,
                        scrollController: scrollController,
                      ),
                    ),
                    // Bottom TextField
                    Padding(
                      padding: EdgeInsets.all(
                       30
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22.r,
                            backgroundImage: NetworkImage(user!.avatar.toString()),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: TextField(
                              controller: bloc.commentTextController,
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                hintStyle: AppTextStyles.description,
                                filled: true,
                                fillColor: AppColors.current.gray.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () async {
                              final text = bloc.commentTextController.text.trim();
                              if (text.isEmpty) return;

                              final userResult = await bloc.getUserDataUseCase.call();
                              userResult.fold(
                                    (failure) => ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(failure.message)),
                                ),
                                    (userData) {
                                  final hasMention = text.startsWith('@') || text.contains(RegExp(r'\s@'));
                                   final parentCommentId = hasMention ? bloc.state.replyingTo?.id : null;

                                  final comment = CommentEntity(
                                    id: 0,
                                    text: text,
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
                                    postId: postId,
                                    parentCommentId: parentCommentId,
                                    replies: [],
                                  );
                                 bloc.add(AddCommentEvent(comment));
                                 bloc.commentTextController.clear();
                                  bloc.add(SetReplyingToEvent(null));
                                },
                              );
                            },
                            child: SvgPicture.asset('assets/icons/add_comment.svg'),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

