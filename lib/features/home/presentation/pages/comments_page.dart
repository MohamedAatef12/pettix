import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/features/home/presentation/widgets/comments_body.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.white,
      appBar: AppBar(
        backgroundColor: AppColors.current.primary,
        elevation: 0,
        title: Text(
          'Comments',
          style: TextStyle(
            color: AppColors.current.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            context.pushReplacement('/bottom_nav'); // للرجوع
          },
          child: Icon(
            Icons.chevron_left,
            color: AppColors.current.white,
            size: 35.r,
          ),
        ),
      ),
      body: const CommentsBody(),

      // 👇 الجزء المثبت أسفل الشاشة
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.r,
              offset: Offset(0, -2.h),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundImage: const AssetImage('assets/images/profile_photo.png'),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomTextFormField(
                  fillColor: true,
                    fillColorValue: AppColors.current.lightGray,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                  ),
                ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: () {
                  // send comment action
                },
                child: SvgPicture.asset('assets/icons/add_comment.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
