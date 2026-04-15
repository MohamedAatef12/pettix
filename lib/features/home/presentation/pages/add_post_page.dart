import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/home/domain/usecases/add_comment.dart';
import 'package:pettix/features/home/domain/usecases/add_comment_like.dart';
import 'package:pettix/features/home/domain/usecases/add_post.dart';
import 'package:pettix/features/home/domain/usecases/add_report.dart';
import 'package:pettix/features/home/domain/usecases/delete_post.dart';
import 'package:pettix/features/home/domain/usecases/dislike_post.dart';
import 'package:pettix/features/home/domain/usecases/get_comment_likes.dart';
import 'package:pettix/features/home/domain/usecases/get_comments_id.dart';
import 'package:pettix/features/home/domain/usecases/get_post_comments_count.dart';
import 'package:pettix/features/home/domain/usecases/get_posts.dart';
import 'package:pettix/features/home/domain/usecases/get_posts_likes.dart';
import 'package:pettix/features/home/domain/usecases/get_report_reasons.dart';
import 'package:pettix/features/home/domain/usecases/get_reported_posts.dart';
import 'package:pettix/features/home/domain/usecases/get_saved_posts.dart';
import 'package:pettix/features/home/domain/usecases/get_user_cached%20_data.dart';
import 'package:pettix/features/home/domain/usecases/get_user_posts.dart';
import 'package:pettix/features/home/domain/usecases/like_post.dart';
import 'package:pettix/features/home/domain/usecases/save_post_usecase.dart';
import 'package:pettix/features/home/domain/usecases/unlike_comment.dart';
import 'package:pettix/features/home/domain/usecases/unsave_post_usecase.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/widgets/add_post_body.dart';

class AddPostPage extends StatelessWidget {
  final HomeBloc? bloc;
  const AddPostPage({super.key, this.bloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightGray,
      body: SafeArea(
        child: bloc != null
            ? BlocProvider.value(
                value: bloc!,
                child: const AddPostBody(),
              )
            : BlocProvider<HomeBloc>(
                create: (context) => HomeBloc.fromDI(),
                child: const AddPostBody(),
              ),
      ),
    );
  }
}
