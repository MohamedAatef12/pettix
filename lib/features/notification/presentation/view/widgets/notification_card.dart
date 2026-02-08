import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

class NotificationCard extends StatelessWidget {
  final Color color;
  const NotificationCard({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/notification_icon.png'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification Title',
                  style: AppTextStyles.bodyTitle
                ),
                 SizedBox(height: 4.h),
                Text(
                  'This is a brief description of the notification. It provides more details about the notification content.',
                  style: AppTextStyles.description
                ),
                 SizedBox(height: 8.h),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle mark as read action
                      },
                      child: Text(
                        'Mark as read',
                        style: AppTextStyles.smallDescription.copyWith(
                          color: AppColors.current.green,
                        )
                      ),
                    ),
                    Spacer(),
                    Text(
                      '2 hours ago',
                      style: AppTextStyles.smallDescription.copyWith(
                        color:AppColors.current.lightText
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
