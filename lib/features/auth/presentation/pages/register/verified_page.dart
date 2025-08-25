import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';

class VerifiedPage extends StatelessWidget {
  const VerifiedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SvgPicture.asset('assets/images/verified.svg',
              fit: BoxFit.fill,
              width: MediaQuery.sizeOf(context).width,),
           Text('verified!', style: AppTextStyles.title
           
           ),
             SizedBox(height: 10.h,),
            Text('Your identity has been successfully verified.', style: AppTextStyles.description),
            SizedBox(height: 30.h,),
            CustomFilledButton(text: 'Done', onPressed: (){
              context.pushReplacement('/login');
            },backgroundColor: AppColors.current.primary,),
            SizedBox(height: 20.h,),
          ],
        ),
      ),
    );
  }
}
