
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';

class AddPostBody extends StatelessWidget {
  const AddPostBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.medium, child: Column(
        children: [
          Row(
            children: [
            GestureDetector(
              onTap: (){
                context.pushReplacement('/bottom_nav');
              },
              child: Image.asset('assets/icons/close.png',
              width: 35.w,
              height: 35.h,
              ),
            ),
              Spacer(),
              Container(
                width: 80.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.current.primary,
                  borderRadius: BorderRadius.circular(8.r)
                ),
                child: Center(
                  child: Text('Share', style: TextStyle(
                    color: AppColors.current.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20.h,),
         Row(
          children: [
            CircleAvatar(
              radius: 25.r,
              backgroundImage: AssetImage('assets/images/profile_photo.png'),
            ),
           SizedBox(width: 10.w,),
          Text('John Doe', style:AppTextStyles.bold)
          ],
         ),
          SizedBox(height: 20.h,),
          CustomTextFormField(
            hintText: 'Write a caption...',
            maxLines: 5,
            contentPadding: EdgeInsets.all(12.w),
            border: InputBorder.none,        // ⬅️ مفيش border أساسي
            enabledBorder: InputBorder.none, // ⬅️ مفيش border لما يبقى enabled
            focusedBorder: InputBorder.none, // ⬅️ مفيش border لما يتعمل focus
          ),
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.current.lightGray,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: SvgPicture.asset('assets/icons/add_photo.svg'),
                ),
              ),
              SizedBox(width: 20.h,),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.current.lightGray,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: SvgPicture.asset('assets/icons/camera.svg'),
                ),
              )
            ],
          ),

        ],
      ),
    );
  }
}
