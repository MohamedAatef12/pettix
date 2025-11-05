import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pinput/pinput.dart';

class OTPBody extends StatefulWidget {
  const OTPBody({super.key});

  @override
  State<OTPBody> createState() => _OTPBodyState();
}

class _OTPBodyState extends State<OTPBody> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _otpSent = false;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.unimtx.com/',
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static const String accessKeyId = 'JDaD3zRe83tM3QpWcmcJST'; // your key

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      _showSnackBar('Please enter your phone number');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _dio.post(
        '?action=otp.send&accessKeyId=$accessKeyId',
        data: {"to": phone, "digits": 6, "channel": "sms", "intent": "login"},
      );

      log('Send OTP Response: ${response.data}');
      if (response.data['code'].toString() == '0') {
        _showSnackBar('OTP sent successfully!');
        setState(() => _otpSent = true);
      } else {
        _showSnackBar('Failed to send OTP: ${response.data['message']}');
      }
    } catch (e) {
      _showSnackBar('Error sending OTP: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    final phone = _phoneController.text.trim();
    final code = _otpController.text.trim();

    if (code.isEmpty) {
      _showSnackBar('Please enter the OTP code');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _dio.post(
        '?action=otp.verify&accessKeyId=$accessKeyId',
        data: {"to": phone, "code": code},
      );

      log('Verify OTP Response: ${response.data}');
      if (response.data['code'].toString() == '0') {
        _showSnackBar('✅ Verification successful!');
        context.go('/verified');
      } else {
        _showSnackBar('❌ Invalid OTP: ${response.data['message']}');
      }
    } catch (e) {
      _showSnackBar('Error verifying OTP: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    log('SnackBar: $message');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/images/otp_verification.svg',
            fit: BoxFit.fill,
            width: MediaQuery.sizeOf(context).width,
          ),
          Text('OTP Verification', style: AppTextStyles.title),
          SizedBox(height: 10.h),
          Text(
            'Enter your phone number to receive the code',
            style: AppTextStyles.smallDescription,
          ),
          SizedBox(height: 30.h),

          // 🔹 Phone number input
          CustomTextFormField(
            controller: _phoneController,
            hintText: '+2010xxxxxxx',
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 20.h),

          // 🔹 Send OTP Button (FIXED)
          if (!_otpSent)
            CustomFilledButton(
              onPressed: () => _isLoading ? null : _sendOtp(), // ✅ FIXED HERE
              text: _isLoading ? 'Sending...' : 'Send OTP',
              backgroundColor: AppColors.current.primary,
              textColor: AppColors.current.white,
            ),

          if (_otpSent) ...[
            SizedBox(height: 40.h),
            Text(
              'Enter the code sent to your phone',
              style: AppTextStyles.smallDescription,
            ),
            SizedBox(height: 20.h),

            // 🔹 OTP Input
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
            SizedBox(height: 40.h),

            // 🔹 Verify Button (FIXED)
            CustomFilledButton(
              onPressed: () => _isLoading ? null : _verifyOtp(), // ✅ FIXED HERE
              text: _isLoading ? 'Verifying...' : 'Verify',
              backgroundColor: AppColors.current.primary,
              textColor: AppColors.current.white,
            ),
            SizedBox(height: 20.h),

            // 🔹 Resend link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Didn’t receive code? ',
                  style: AppTextStyles.smallDescription.copyWith(
                    color: AppColors.current.gray,
                  ),
                ),
                GestureDetector(
                  onTap:
                      () => _isLoading ? null : _sendOtp(), // ✅ FIXED HERE TOO
                  child: Text(
                    'Resend',
                    style: AppTextStyles.smallDescription.copyWith(
                      color: AppColors.current.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
