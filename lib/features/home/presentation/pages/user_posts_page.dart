import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/widgets/home_body.dart';

class UserPostsPage extends StatelessWidget {
  final int contactId;
  const UserPostsPage({super.key, required this.contactId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      appBar: AppTopBar.back(
        title: AppText.myPosts,
        backgroundColor: AppColors.current.lightBlue,
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocProvider(
          create: (context) => HomeBloc.fromDI()..add(GetUserPostsEvent()),
          child: Column(
            children: [SizedBox(height: 10.h), Expanded(child: HomeBody())],
          ),
        ),
      ),
    );
  }
}
