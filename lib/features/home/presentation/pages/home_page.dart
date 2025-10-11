import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/widgets/home_appbar.dart';
import 'package:pettix/features/home/presentation/widgets/home_body.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      body: SafeArea(child: BlocProvider(
          create: (context) => HomeBloc.fromDI()
            ..add(
              FetchPostsEvent(),
            ),
          child: Column(
            children: [
              HomeAppBar(),
              SizedBox(height: 10.h),
              HomeBody(),
            ],
          ))),
    );
  }
}
