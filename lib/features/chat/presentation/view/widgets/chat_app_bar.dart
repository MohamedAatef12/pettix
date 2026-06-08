import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';

import 'package:pettix/core/widgets/app_profile_image.dart';

class ChatAppBar extends StatelessWidget {
  final String text;
  final String? avatarUrl;
  final int? conversationId;
  final int? contactId;

  const ChatAppBar({
    super.key,
    required this.text,
    this.avatarUrl,
    this.conversationId,
    this.contactId,
  });

  @override
  Widget build(BuildContext context) {
    Widget? avatarWidget;
    if (avatarUrl != null) {
      avatarWidget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: AppProfileImage(imageUrl: avatarUrl, radius: 18.r),
      );

      if (conversationId != null) {
        avatarWidget = Hero(
          tag: 'conversation_avatar_$conversationId',
          child: avatarWidget,
        );
      }
    }

    final profileHeader = GestureDetector(
      onTap:
          contactId == null || contactId == 0
              ? null
              : () => context.push(AppRoutes.userProfile, extra: contactId),
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          if (avatarWidget != null) avatarWidget,
          SizedBox(width: avatarWidget == null ? 0 : 12.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.appbar,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    return Row(
      children: [
        AppTopBarBackButton(onPressed: () => Navigator.pop(context)),
        SizedBox(width: 8.w),
        Expanded(child: profileHeader),
        SizedBox(width: 15.w),
      ],
    );
  }
}
