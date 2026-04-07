import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_state.dart';
import 'package:pettix/features/notification/presentation/view/widgets/notification_card.dart';
import 'package:pettix/features/notification/presentation/view/widgets/notification_shimmer.dart';
import 'package:pettix/features/notification/presentation/view/widgets/empty_notifications.dart';

class AllNotifications extends StatelessWidget {
  const AllNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state.status == NotificationStatus.loading) {
          return const NotificationShimmer();
        }
        if (state.status == NotificationStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48.sp, color: AppColors.current.red),
                SizedBox(height: 16.h),
                Text(state.errorMessage, style: AppTextStyles.description),
              ],
            ),
          );
        }
        if (state.notifications.isEmpty) {
          return const Center(
            child: EmptyNotifications(),
          );
        }
        return ListView.builder(
            itemCount: state.notifications.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 20.h),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final notification = state.notifications[index];
              return NotificationCard(
                color: AppColors.current.white,
                notification: notification,
              );
            });
      },
    );
  }
}
