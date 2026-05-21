import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/themes/app_colors.dart';
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
