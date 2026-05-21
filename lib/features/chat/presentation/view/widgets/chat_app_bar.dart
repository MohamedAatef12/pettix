import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/widgets/rtl_aware_icon.dart';

import 'package:pettix/core/widgets/app_profile_image.dart';

class ChatAppBar extends StatelessWidget {
  final String text;
  final String? avatarUrl;
  final int? conversationId;

  const ChatAppBar({
    super.key,
    required this.text,
    this.avatarUrl,
    this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    Widget? avatarWidget;
    if (avatarUrl != null) {
      avatarWidget = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
        ),
        child: AppProfileImage(
          imageUrl: avatarUrl,
          radius: 18.r,
        ),
      );

      if (conversationId != null) {
        avatarWidget = Hero(
          tag: 'conversation_avatar_$conversationId',
          child: avatarWidget,
        );
      }
    }

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: RtlAwareIcon(
            child: SvgPicture.asset('assets/icons/backButton.svg'),
          ),
        ),
        SizedBox(width: 8.w),
        if (avatarWidget != null) avatarWidget,
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.appbar,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(width: 15.w,),
      ],
    );
  }
}
