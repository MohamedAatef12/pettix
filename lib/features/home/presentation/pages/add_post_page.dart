import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/home/domain/usecases/add_comment.dart';
import 'package:pettix/features/home/domain/usecases/add_post.dart';
import 'package:pettix/features/home/domain/usecases/delete_post.dart';
import 'package:pettix/features/home/domain/usecases/dislike_post.dart';
import 'package:pettix/features/home/domain/usecases/get_comments_id.dart';
import 'package:pettix/features/home/domain/usecases/get_posts.dart';
import 'package:pettix/features/home/domain/usecases/get_posts_likes.dart';
import 'package:pettix/features/home/domain/usecases/get_user_cached%20_data.dart';
import 'package:pettix/features/home/domain/usecases/like_post.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/widgets/add_post_body.dart';

class AddPostPage extends StatelessWidget {
  const AddPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightGray,
      body: SafeArea(
        child: BlocProvider<HomeBloc>(
          create:
              (context) => HomeBloc(
                getPostsUseCase: getIt<GetPostsUseCase>(),
                addPostUseCase: getIt<AddPostUseCase>(),
                deletePostUseCase: getIt<DeletePostUseCase>(),
                addCommentUseCase: getIt<AddCommentUseCase>(),
                getCommentsIdUseCase: getIt<GetPostCommentsUseCase>(),
                getPostsLikesUseCase: getIt<GetPostLikesUseCase>(),
                unlikePostUseCase: getIt<UnLikePostUseCase>(),
                likePostUseCase: getIt<LikePostUseCase>(),
                getUserDataUseCase: getIt<GetUserDataUseCase>(),
              ),
          child: AddPostBody(),
        ),
      ),
    );
  }
}
