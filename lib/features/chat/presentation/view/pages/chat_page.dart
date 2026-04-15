import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat_app_bar.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat/chat_body.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_event.dart';

class ChatPage extends StatelessWidget {
  final int index;
  const ChatPage({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      body: BlocProvider(
        create: (context) => DI.find<ChatBloc>()..add(GetMessagesEvent(index, isRefresh: true)),
        child: SafeArea(
          child: Column(
            children: [
              ChatAppBar(text: 'User $index',),
              SizedBox(height: 10.h),
              Expanded(child: ChatBody(index: index,)),
            ],
          ),
        ),
      ),
    );
  }
}

