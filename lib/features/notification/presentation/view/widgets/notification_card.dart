import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/date_formatter.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_event.dart';
import '../../../domain/entities/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  final Color color;
  final NotificationEntity notification;

  const NotificationCard({
    super.key,
    required this.color,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? color : AppColors.current.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.current.primary.withOpacity(0.1),
              child: Icon(Icons.notifications_rounded, size: 20.sp, color: AppColors.current.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: AppTextStyles.bold.copyWith(fontSize: 14.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.body,
                    style: AppTextStyles.description.copyWith(fontSize: 13.sp),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      if (!notification.isRead)
                        GestureDetector(
                          onTap: () {
                            context.read<NotificationBloc>().add(MarkAsReadEvent(notification.id));
                          },
                          child: Text(
                            'Mark as read',
                            style: AppTextStyles.smallDescription.copyWith(
                              color: AppColors.current.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const Spacer(),
                      Text(
                        DateFormatter.formatTimeAgo(notification.date),
                        style: AppTextStyles.smallDescription.copyWith(
                          color: AppColors.current.lightText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
