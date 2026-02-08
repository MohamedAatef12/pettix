import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat_list/chat_list_taps.dart';

class ChatListBody extends StatelessWidget {
  const ChatListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.horizontalMedium,
      child: Column(
        children: [
          CustomTextFormField(
            fillColor: true,
            fillColorValue: AppColors.current.lightGray,
            hintText: 'Search',
            border: InputBorder.none, // ⬅️ مفيش border أساسي
            enabledBorder: InputBorder.none, // ⬅️ مفيش border لما يبقى enabled
            focusedBorder: InputBorder.none,
            leading: SvgPicture.asset('assets/icons/search_grey.svg'),
            suffixIcon: SvgPicture.asset('assets/icons/filter.svg'),
          ),
          SizedBox(height: 15.h,),
          Expanded(child: ChatListTaps())
        ],
      ),
    );
  }
}
