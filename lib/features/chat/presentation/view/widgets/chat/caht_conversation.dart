import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat/profile_card.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_event.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_state.dart';

class ChatConversation extends StatefulWidget {
  final int userIndex;
  const ChatConversation({super.key, required this.userIndex});

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50) {
      final state = context.read<ChatBloc>().state;
      if (state.hasMore && state.status != ChatStatus.paginating && state.status != ChatStatus.loading) {
        context.read<ChatBloc>().add(GetMessagesEvent(widget.userIndex));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.status == ChatStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == ChatStatus.error) {
          return Center(child: Text(state.errorMessage, style: const TextStyle(color: Colors.red)));
        }

        final messages = state.messages;

        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length + 1 + (state.status == ChatStatus.paginating ? 1 : 0),
          padding: EdgeInsets.only(bottom: 16.h),
          // We usually reverse the list for chat, but based on your previous items logic:
          // We might need to handle reverse=true, or just build standard. Assuming index 0 is top.
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  ProfileCard(index: widget.userIndex),
                  SizedBox(height: 10.h),
                ],
              );
            }

            if (index > messages.length) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final msg = messages[index - 1];
            // Assuming `senderId` matches your current user ID logic for `isMe`. 
            // In a real app you'd compare msg.senderId == currentUserId.
            // Using a dummy check for now or assuming isMe if senderId != the other user id.
            final isMe = msg.senderId != widget.userIndex; // Or whatever logic you use

            return ChatBubble(
              text: msg.content,
              isMe: isMe,
              seen: false, // Update logic when seen property is fully mapped if available
            );
          },
        );
      },
    );
  }
}


class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final bool seen;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    this.seen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        constraints: BoxConstraints(maxWidth: 260.w),
        decoration: BoxDecoration(
          color: isMe
              ? AppColors.current.primary
              : AppColors.current.blueGray.withValues(alpha: 0.4),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.r),
            topRight: Radius.circular(14.r),
            bottomLeft: isMe ? Radius.circular(14.r) : Radius.circular(0),
            bottomRight: isMe ? Radius.circular(0) : Radius.circular(14.r),
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 30.w, bottom: 6.h),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : AppColors.current.text,
                  fontSize: 14.sp,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    seen
                        ? Icons.done_all
                        : Icons.done,
                    size: 16.w,
                    color: isMe
                        ? (seen
                        ? Colors.blueAccent
                        : Colors.white70)
                        : (seen
                        ? Colors.blueAccent
                        : Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
