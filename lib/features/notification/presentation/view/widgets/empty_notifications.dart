import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/images/no_notification.png'),
        SizedBox(height: 10.h),
        Text('No Notifications', style: AppTextStyles.title),
        SizedBox(height: 5.h),
        Text(
          'You have no notifications yet,\n please Come back later.',
          style: AppTextStyles.description.copyWith(color: Colors.grey),
        textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
