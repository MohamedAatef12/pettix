import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat/profile_card.dart';

class ChatConversation extends StatelessWidget {
  final int userIndex;
  const ChatConversation({super.key, required this.userIndex});

  @override
  Widget build(BuildContext context) {
    final messages = [
      {"text": "Hey, how are you?", "isMe": false, "seen": true},
      {"text": "I’m good! What about you?", "isMe": true, "seen": true},
      {"text": "All good here, just chilling 😄", "isMe": false, "seen": true},
      {"text": "Nice! Are you coming to the meetup?", "isMe": true, "seen": false},
      {"text": "Yes, I’ll be there around 6 PM.", "isMe": false, "seen": true},
      {"text": "Great! See you then.", "isMe": true, "seen": false},
      {"text": "See you!", "isMe": false, "seen": true},
    ];

    return ListView.builder(
      itemCount: messages.length + 1,
      padding: EdgeInsets.only(bottom: 16.h),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              ProfileCard(index: userIndex),
              SizedBox(height: 10.h),
            ],
          );
        }

        final msg = messages[index - 1];
        return ChatBubble(
          text: msg["text"] as String,
          isMe: msg["isMe"] as bool,
          seen: msg["seen"] as bool? ?? false,
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
              : AppColors.current.blueGray.withOpacity(0.4),
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
