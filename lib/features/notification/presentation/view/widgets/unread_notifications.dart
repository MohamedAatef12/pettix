import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_state.dart';
import 'package:pettix/features/notification/presentation/view/widgets/notification_card.dart';

class UnreadNotifications extends StatelessWidget {
  const UnreadNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        final unreadNotifications = state.notifications.where((n) => !n.isRead).toList();
        
        if (state.status == NotificationStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == NotificationStatus.error) {
          return Center(child: Text(state.errorMessage));
        }
        if (unreadNotifications.isEmpty) {
          return const Center(child: Text("No unread notifications"));
        }
        return ListView.builder(
            itemCount: unreadNotifications.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return NotificationCard(
                color: AppColors.current.white,
                notification: unreadNotifications[index],
              );
            });
      },
    );
  }
}
