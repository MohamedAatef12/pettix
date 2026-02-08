import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_event.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_state.dart';
import 'package:pinput/pinput.dart';

class OTPBody extends StatelessWidget {
   OTPBody({super.key});
  final _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<AuthBloc,AuthState>(
        builder: (context,state) {
          return Column(
            children: [
              SvgPicture.asset(
                'assets/images/otp_verification.svg',
                fit: BoxFit.fill,
                width: MediaQuery.sizeOf(context).width,
              ),
              Text(AppText.otpVerification, style: AppTextStyles.title),
              SizedBox(height: 10.h,),
              Text(AppText.enterOtpSent, style: AppTextStyles.smallDescription),
              SizedBox(height: 40.h,),
              Pinput(
                length: 6,
                controller: _otpController,
                keyboardType: TextInputType.number,
                defaultPinTheme: PinTheme(
                  width: 60,
                  height: 60,
                  textStyle: const TextStyle(fontSize: 22),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              SizedBox(height: 20.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppText.didntReceiveCode,style: AppTextStyles.smallDescription.copyWith(
                    color: AppColors.current.gray,
                  ),),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Text(AppText.resend,style: AppTextStyles.smallDescription.copyWith(
                      color: AppColors.current.primary,
                      fontWeight: FontWeight.w600,
                    ),),
                  ),
                ],
              ),
              SizedBox(height: 40.h,),
              CustomFilledButton(
                onPressed: () {
                  final otp =  _otpController.text;
                  context.read<AuthBloc>().add(RegisterOtpSubmitted(otp));
                  context.go('/verified');
                },
                text: AppText.verify,
                backgroundColor: AppColors.current.primary,
                textColor: AppColors.current.white,

              ),
              SizedBox(height: 20.h,),
            ],
          );
        }
      ),
    );
  }
}
