import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/widgets/app_search_bar.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_list_bloc.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_list_event.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat_list/chat_list_taps.dart';

class ChatListBody extends StatelessWidget {
  const ChatListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.horizontalMedium,
      child: Column(
        children: [
          AppSearchBar(
            hintText: AppText.searchConversations,
            onChanged: (value) {
              context.read<ChatListBloc>().add(SearchConversationsEvent(value));
            },
          ),
          const SizedBox(height: 24),
          const Expanded(child: ChatListTaps()),
        ],
      ),
    );
  }
}
