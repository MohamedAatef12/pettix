import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
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

  IconData _getIcon() {
    final title = notification.title.toLowerCase();
    final body = notification.body.toLowerCase();

    if (title.contains('like') || body.contains('like') || title.contains('love') || body.contains('love')) {
      return Icons.favorite_rounded;
    }
    if (title.contains('comment') || body.contains('comment') || title.contains('reply') || body.contains('reply')) {
      return Icons.chat_bubble_rounded;
    }

    switch (notification.notificationTypeId) {
      case 1: // Timeline/Social
        return Icons.feed_rounded;
      case 2: // Store
        return Icons.shopping_bag_rounded;
      case 3: // Clinic
        return Icons.medical_services_rounded;
      case 4: // Emergency
        return Icons.emergency_rounded;
      case 5: // Adoption
        return Icons.pets_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getIconColor() {
    final title = notification.title.toLowerCase();
    final body = notification.body.toLowerCase();

    if (title.contains('like') || body.contains('like') || title.contains('love') || body.contains('love')) {
      return const Color(0xFFFF4081); // Pink
    }
    if (title.contains('comment') || body.contains('comment') || title.contains('reply') || body.contains('reply')) {
      return const Color(0xFF2196F3); // Blue
    }

    switch (notification.notificationTypeId) {
      case 1:
        return AppColors.current.primary;
      case 2:
        return const Color(0xFF9C27B0); // Purple
      case 3:
        return const Color(0xFF009688); // Teal
      case 4:
        return const Color(0xFFEA4335); // Red
      case 5:
        return AppColors.current.primary;
      default:
        return AppColors.current.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          context.read<NotificationBloc>().add(MarkAsReadEvent(notification.id));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: notification.isRead ? color : AppColors.current.primary.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: notification.isRead 
                ? Colors.transparent 
                : AppColors.current.primary.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              spreadRadius: 0,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              if (!notification.isRead)
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: 4.w,
                    decoration: BoxDecoration(
                      color: AppColors.current.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        bottomLeft: Radius.circular(20.r),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Section
                    Container(
                      height: 52.h,
                      width: 52.w,
                      decoration: BoxDecoration(
                        color: _getIconColor().withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getIconColor().withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        _getIcon(),
                        size: 24.sp,
                        color: _getIconColor(),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Text Content Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: AppTextStyles.bold.copyWith(
                                    fontSize: 15.sp,
                                    color: AppColors.current.text,
                                    letterSpacing: -0.2,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                DateFormatter.formatTimeAgo(notification.date),
                                style: AppTextStyles.smallDescription.copyWith(
                                  fontSize: 11.sp,
                                  color: AppColors.current.lightText.withOpacity(0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            notification.body,
                            style: AppTextStyles.description.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.current.text.withOpacity(0.7),
                              height: 1.4,
                            ),
                          ),
                          if (!notification.isRead) ...[
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 8.sp,
                                  color: AppColors.current.primary,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  AppText.new_,
                                  style: AppTextStyles.bold.copyWith(
                                    fontSize: 11.sp,
                                    color: AppColors.current.primary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
