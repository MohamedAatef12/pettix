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
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.current.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: AppColors.current.white, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CustomTextFormField(
              fillColor: true,
              fillColorValue: Colors.transparent,
              hintText: 'Search conversations...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              leading: Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: SvgPicture.asset(
                  'assets/icons/search_grey.svg',
                  width: 16.w,
                  colorFilter: ColorFilter.mode(AppColors.current.gray, BlendMode.srcIn),
                ),
              ),
              suffixIcon: SvgPicture.asset(
                'assets/icons/filter.svg',
                width: 18.w,
                colorFilter: ColorFilter.mode(AppColors.current.primary, BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          const Expanded(child: ChatListTaps())
        ],
      ),
    );
  }
}
