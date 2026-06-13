import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat_app_bar.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat/chat_body.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';
import 'package:pettix/features/adoption_history/presentation/bloc/adoption_history_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_event.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_state.dart';

class ChatPage extends StatelessWidget {
  final int index;
  final bool isUserId;
  final String? initialName;
  final String? initialAvatar;
  final AdoptionFormEntity? adoptionForm;
  final AdoptionHistoryBloc? adoptionHistoryBloc;

  const ChatPage({
    super.key,
    required this.index,
    this.isUserId = false,
    this.initialName,
    this.initialAvatar,
    this.adoptionForm,
    this.adoptionHistoryBloc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      body: BlocProvider(
        create:
            (context) =>
                DI.find<ChatBloc>()..add(
                  isUserId
                      ? InitializeChatEvent(otherUserId: index)
                      : InitializeChatEvent(conversationId: index),
                ),
        child: SafeArea(
          child: Column(
            children: [
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  // Identify the "Other Member" to show in the header
                  final otherMember =
                      state.conversation?.members
                          .where((m) => m.user.id != state.currentUserId)
                          .firstOrNull ??
                      (state.conversation?.members.isNotEmpty == true
                          ? state.conversation?.members.first
                          : null);

                  final title =
                      initialName ??
                      otherMember?.user.displayName ??
                      (state.conversation != null
                          ? AppText.chatTitle
                          : AppText.loadingText);

                  final avatarUrl = initialAvatar ?? otherMember?.user.avatar;
                  final contactId =
                      otherMember?.user.id ?? (isUserId ? index : null);

                  return ChatAppBar(
                    text: title,
                    avatarUrl: avatarUrl,
                    conversationId:
                        state.conversation?.id, // Hero uses ID for sync
                    contactId: contactId,
                  );
                },
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ChatBody(
                  index: index,
                  adoptionForm: adoptionForm,
                  adoptionHistoryBloc: adoptionHistoryBloc,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
