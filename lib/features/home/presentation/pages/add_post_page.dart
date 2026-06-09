import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/widgets/add_post_body.dart';

class AddPostPage extends StatelessWidget {
  final HomeBloc? bloc;
  final PostEntity? editingPost;

  const AddPostPage({super.key, this.bloc, this.editingPost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightGray,
      body: SafeArea(
        child:
            bloc != null
                ? BlocProvider.value(
                  value: bloc!,
                  child: AddPostBody(editingPost: editingPost),
                )
                : BlocProvider<HomeBloc>(
                  create: (context) => HomeBloc.fromDI(),
                  child: AddPostBody(editingPost: editingPost),
                ),
      ),
    );
  }
}
