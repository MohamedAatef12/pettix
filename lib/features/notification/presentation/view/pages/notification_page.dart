import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:pettix/features/notification/presentation/view/widgets/notification_app_bar.dart';
import 'package:pettix/features/notification/presentation/view/widgets/notification_body.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightGray,
      body: BlocProvider(
        create: (context) => NotificationBloc(),
        child: SafeArea(
          child: Column(
            children: [
              NotificationAppBar(),
              SizedBox(height: 10.h),
              Expanded(child: NotificationBody()),
            ],
          ),
        ),
      ),
    );
  }
}
