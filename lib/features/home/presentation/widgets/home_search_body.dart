import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';

class HomeSearchBody extends StatelessWidget {
  const HomeSearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.medium,
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.pushReplacement('/bottom_nav'); // للرجوع
                },
                child: Icon(
                  Icons.chevron_left,
                  color: AppColors.current.text,
                  size: 35.r,
                ),
              ),
              Expanded(
                child: CustomTextFormField(
                  fillColor: true,
                  fillColorValue: AppColors.current.lightGray,
                  hintText: 'Search',
                  border: InputBorder.none,        // ⬅️ مفيش border أساسي
                  enabledBorder: InputBorder.none, // ⬅️ مفيش border لما يبقى enabled
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(12.w),
                  leading: SvgPicture.asset('assets/icons/search_grey.svg',),

                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
