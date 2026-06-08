import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';

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
              AppTopBarBackButton(
                onPressed: () {
                  context.pushReplacement('/bottom_nav'); // للرجوع
                },
              ),
              Expanded(
                child: CustomTextFormField(
                  fillColor: true,
                  fillColorValue: AppColors.current.lightGray,
                  hintText: AppText.search,
                  border: InputBorder.none, // ⬅️ مفيش border أساسي
                  enabledBorder:
                      InputBorder.none, // ⬅️ مفيش border لما يبقى enabled
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(12.w),
                  leading: SvgPicture.asset('assets/icons/search_grey.svg'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
