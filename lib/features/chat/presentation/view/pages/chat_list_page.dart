import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat_app_bar.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat_list/chat_list_body.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      body: SafeArea(
        child: Column(
          children: [
            ChatAppBar(text: 'Messages',),
            SizedBox(height: 10.h,),
            Expanded(child: ChatListBody()),
          ],
        ),
      ),
    );
  }
}
