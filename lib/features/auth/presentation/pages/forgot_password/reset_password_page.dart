import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/auth/presentation/widgets/forgot_password/reset_password_body.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.white,
      appBar: AppBar(
        backgroundColor: AppColors.current.white,
    centerTitle: true,
        title: Image.asset('assets/images/horizontal_logo.png'),

        leading: GestureDetector(
         onTap: (){
            Navigator.pop(context);
         },
         child: SvgPicture.asset('assets/icons/backButton.svg')),
        
      ),
      body: ResetPasswordBody(),
    );
  }
}
