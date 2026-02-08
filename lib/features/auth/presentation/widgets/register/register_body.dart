import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/features/auth/presentation/widgets/register/register_form.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.large,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/horizontal_logo.png',
              height: 25.h,width: 100.w,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 20.h,),
            Text(AppText.signUp,
              style: AppTextStyles.title,),

            Text(AppText.createAccountToContinue,style: AppTextStyles.smallDescription,),
            SizedBox(height: 50.h,),
            RegisterForm()
          ],
        ),
      ),
    );
  }
}
