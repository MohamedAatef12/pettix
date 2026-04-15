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
        if (state.conversationId != null) {
          context.read<ChatBloc>().add(GetMessagesEvent(state.conversationId!));
        }
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
          reverse: true,
          itemBuilder: (context, index) {
            // Profile card at the end of the history (top of the scroll view)
            if (index == messages.length) {
              // Identify the "Other Member" to show in the profile card
              final otherMember = state.conversation?.members.where((m) => m.user.id != state.currentUserId).firstOrNull ?? 
                                (state.conversation?.members.isNotEmpty == true ? state.conversation?.members.first : null);
              
              return Column(
                children: [
                   ProfileCard(
                     index: widget.userIndex,
                     name: otherMember?.user.displayName,
                     avatarUrl: otherMember?.user.avatar,
                   ),
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

            final msg = messages[index];
            final isMe = msg.senderId == state.currentUserId;

            return ChatBubble(
              text: msg.content,
              isMe: isMe,
              seen: false, 
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
