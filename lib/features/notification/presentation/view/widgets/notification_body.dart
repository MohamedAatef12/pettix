import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/enums/app_enums.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_event.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_state.dart';
import 'package:pettix/features/notification/presentation/view/widgets/all_notifications.dart';
import 'package:pettix/features/notification/presentation/view/widgets/notifications_tab_bar.dart';

class NotificationBody extends StatelessWidget {
  const NotificationBody({super.key});

  String _getTranslatedTitle(NotificationType type) {
    switch (type) {
      case NotificationType.timeline:
        return AppText.timeline;
      case NotificationType.store:
        return AppText.store;
      case NotificationType.clinic:
        return AppText.clinics;
      case NotificationType.emergency:
        return AppText.emergency;
      case NotificationType.adoption:
        return AppText.adoption;
      default:
        return AppText.all;
    }
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.timeline:
        return Icons.feed_rounded;
      case NotificationType.store:
        return Icons.shopping_bag_rounded;
      case NotificationType.clinic:
        return Icons.medical_services_rounded;
      case NotificationType.emergency:
        return Icons.emergency_rounded;
      case NotificationType.adoption:
        return Icons.pets_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        final List<Widget> tabs = List.generate(
          NotificationType.values.length,
          (index) => const AllNotifications(),
        );

        return Container(
          color: AppColors.current.white,
          child: Column(
            children: [
              // Tab Bar Section
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.current.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: NotificationType.values.map((type) {
                      final tabIndex = NotificationType.values.indexOf(type);
                      return Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: NotificationsTabButton(
                          title: _getTranslatedTitle(type),
                          icon: _getIconForType(type),
                          index: tabIndex,
                          currentIndex: state.currentIndex,
                          unreadCount: state.unreadCountsByType[type.value] ?? 0,
                          onTap: () {
                            context.read<NotificationBloc>().add(ChangeNotificationTab(tabIndex));
                            context.read<NotificationBloc>().add(GetNotificationsEvent(
                                  notificationTypeId: type.value,
                                ));
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              
              // Secondary Actions / Stats
              Padding(
                padding: EdgeInsets.only(left:20.w, right:20.w,bottom:  4.h),
                child: Row(
                  children: [
                    Text(
                      _getTranslatedTitle(NotificationType.values[state.currentIndex]),
                      style: AppTextStyles.description.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.current.lightText.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        final currentType = NotificationType.values[state.currentIndex];
                        context.read<NotificationBloc>().add(MarkAllAsReadEvent(currentType.value));
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.current.primary,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        AppText.markAllAsReadNotify,
                        style: AppTextStyles.bold.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Notifications Content
              Expanded(
                child: IndexedStack(
                  index: state.currentIndex < tabs.length ? state.currentIndex : 0,
                  children: tabs,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
