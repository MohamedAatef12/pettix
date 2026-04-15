import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat_app_bar.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat/chat_body.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_event.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_state.dart';

class ChatPage extends StatelessWidget {
  final int index;
  final bool isUserId;
  const ChatPage({super.key, required this.index, this.isUserId = false});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      body: BlocProvider(
        create: (context) => DI.find<ChatBloc>()
          ..add(isUserId
              ? InitializeChatEvent(otherUserId: index)
              : InitializeChatEvent(conversationId: index)),
        child: SafeArea(
          child: Column(
            children: [
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  // Filter out current user to get the display name
                  final members = state.conversation?.members ?? [];
                  final otherMember = members.where((m) => m.user.id != state.currentUserId).firstOrNull ?? 
                                    (members.isNotEmpty ? members.first : null);
                  final title = otherMember?.user.displayName ?? (state.conversation != null ? 'Chat' : 'User $index');
                  return ChatAppBar(text: title);
                },
              ),
              SizedBox(height: 10.h),
              Expanded(child: ChatBody(index: index,)),
            ],
          ),
        ),
      ),
    );
  }
}

