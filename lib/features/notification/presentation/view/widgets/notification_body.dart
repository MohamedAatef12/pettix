import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/enums/app_enums.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_event.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_state.dart';
import 'package:pettix/features/notification/presentation/view/widgets/all_notifications.dart';
import 'package:pettix/features/notification/presentation/view/widgets/notifications_tab_bar.dart';

class NotificationBody extends StatelessWidget {
  const NotificationBody({super.key});

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

        return Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: NotificationType.values.map((type) {
                  final tabIndex = NotificationType.values.indexOf(type);
                  return Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: NotificationsTabButton(
                      title: type.name[0].toUpperCase() + type.name.substring(1),
                      icon: _getIconForType(type),
                      index: tabIndex,
                      currentIndex: state.currentIndex,
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      final currentType = NotificationType.values[state.currentIndex];
                      context.read<NotificationBloc>().add(MarkAllAsReadEvent(currentType.value));
                    },
                    icon: Icon(Icons.done_all_rounded, size: 18.sp, color: AppColors.current.primary),
                    label: Text(
                      "Mark all as read",
                      style: AppTextStyles.bold.copyWith(
                        fontSize: 13.sp,
                        color: AppColors.current.primary,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: IndexedStack(
                index: state.currentIndex < tabs.length ? state.currentIndex : 0,
                children: tabs,
              ),
            ),
          ],
        );
      },
    );
  }
}
