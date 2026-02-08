import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/core/constants/text_styles.dart';

class ChatAppBar extends StatelessWidget {
  final String text;
  const ChatAppBar({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: SvgPicture.asset('assets/icons/backButton.svg'),
        ),
        Spacer(),
        Text(
            text,
            style: AppTextStyles.appbar
        ),
        Spacer(),
        GestureDetector(
          onTap: (){},
          child: Image.asset('assets/icons/settings.png'),
        ),
        SizedBox(width: 15.w,),
      ],
    );
  }
}
