import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
class ChatTextFormField extends StatelessWidget {
  const ChatTextFormField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.lightGray,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: AppColors.current.gray.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          SizedBox(width: 15.w),
          SvgPicture.asset(
            'assets/icons/mic.svg',
            width: 20.w,
            height: 20.h,
            colorFilter: ColorFilter.mode(
              AppColors.current.gray,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(
            height: 24.h, // set divider height manually
            child: VerticalDivider(
              color: AppColors.current.gray.withOpacity(0.4),
              thickness: 0.8,
              width: 20.w, // adds spacing around the line
            ),
          ),

          SvgPicture.asset(
            'assets/icons/pencil.svg',
            width: 20.w,
            height: 20.h,
          ),

          Expanded(
            child: CustomTextFormField(
              fillColor: true,
              fillColorValue: AppColors.current.lightGray,
              hintText: 'write your message here',
              border: InputBorder.none, // ⬅️ مفيش border أساسي
              enabledBorder:
              InputBorder.none, // ⬅️ مفيش border لما يبقى enabled
              focusedBorder: InputBorder.none,
            ),
          ),
          SvgPicture.asset(
            'assets/icons/send.svg',
            width: 20.w,
            height: 20.h,
            colorFilter: ColorFilter.mode(
              AppColors.current.primary,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(
            height: 24.h, // set divider height manually
            child: VerticalDivider(
              color: AppColors.current.gray.withOpacity(0.4),
              thickness: 0.8,
              width: 20.w, // adds spacing around the line
            ),
          ),

          SvgPicture.asset(
            'assets/icons/camera.svg',
            width: 20.w,
            height: 20.h,
            colorFilter: ColorFilter.mode(
              AppColors.current.gray,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }
}