import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_event.dart';
import 'package:pettix/features/auth/presentation/blocs/auth_state.dart';

class OTPBody extends StatelessWidget {
   OTPBody({super.key});
  final _otpControllers = List.generate(4, (_) => TextEditingController());

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
              Text('OTP Verification', style: AppTextStyles.title),
              SizedBox(height: 10.h,),
              Text('Enter the OTP we sent to +45472****', style: AppTextStyles.smallDescription),
              SizedBox(height: 40.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) => SizedBox(
                  width: 50,
                  child: CustomTextFormField(
                    keyboardType: TextInputType.number,
                    controller: _otpControllers[i],
                  ),
                )),
              ),
              SizedBox(height: 20.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Didn’t receive code? ',style: AppTextStyles.smallDescription.copyWith(
                    color: AppColors.current.gray,
                  ),),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Text('Resend',style: AppTextStyles.smallDescription.copyWith(
                      color: AppColors.current.primary,
                      fontWeight: FontWeight.w600,
                    ),),
                  ),
                ],
              ),
              SizedBox(height: 40.h,),
              CustomFilledButton(
                onPressed: () {
                  final otp = _otpControllers.map((c) => c.text).join();
                  context.read<AuthBloc>().add(RegisterOtpSubmitted(otp));
                  context.go('/verified');
                },
                text: 'Verify',
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
