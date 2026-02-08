import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat/caht_conversation.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat/chat_text_form_fied.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat/profile_card.dart';

class ChatBody extends StatelessWidget {
  final int index;
  const ChatBody({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.medium,
      child: Column(
        children: [
          Expanded(
            child: ChatConversation(userIndex: index,),
          ),
          ChatTextFormField(),
        ],
      ),
    );
  }
}
