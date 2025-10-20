import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat_app_bar.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat/chat_body.dart';

class ChatPage extends StatelessWidget {
  final int index;
  const ChatPage({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      body: SafeArea(
        child: Column(
          children: [
            ChatAppBar(text: 'User $index',),
            SizedBox(height: 10.h),
            Expanded(child: ChatBody(index: index,)),
          ],
        ),
      ),
    );
  }
}
