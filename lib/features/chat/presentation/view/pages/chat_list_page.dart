import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat_app_bar.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat_list/chat_list_body.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_list_bloc.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_list_event.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => DI.find<ChatListBloc>()..add(const GetConversationsEvent()),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.current.white,
                AppColors.current.lightBlue.withValues(alpha: 0.5),
                AppColors.current.lightBlue,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                ChatAppBar(text: 'Messages'),
                SizedBox(height: 10.h),
                Expanded(child: ChatListBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

