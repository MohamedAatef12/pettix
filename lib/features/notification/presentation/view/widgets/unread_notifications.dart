import 'package:flutter/material.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/notification/presentation/view/widgets/empty_notifications.dart';
import 'package:pettix/features/notification/presentation/view/widgets/notification_card.dart';

class UnreadNotifications extends StatelessWidget {
  const UnreadNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder:
            (context, index) {
          return NotificationCard(
            color: AppColors.current.lightYellow
          );
        }
    );
  }
}
