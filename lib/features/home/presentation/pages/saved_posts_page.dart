import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/rtl_aware_icon.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/widgets/home_body.dart';

class SavedPostsPage extends StatelessWidget {
  const SavedPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      appBar: AppBar(
        title: Text(AppText.savedPosts, style: AppTextStyles.appbar),
        centerTitle: true,
        backgroundColor: AppColors.current.lightBlue,
        leading: RtlAwareIcon(
          child: IconButton(
            icon: Icon(Icons.chevron_left, size: 26.r),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: BlocProvider(
          create: (context) => HomeBloc.fromDI()..add(GetSavedPostsEvent()),
          child: Column(
            children: [SizedBox(height: 10.h), Expanded(child: HomeBody())],
          ),
        ),
      ),
    );
  }
}
