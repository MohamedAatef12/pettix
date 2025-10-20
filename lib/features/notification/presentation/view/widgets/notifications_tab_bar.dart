import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_events.dart';

class NotificationsTabButton extends StatelessWidget {
  final String title;
  final int index;
  final int currentIndex;

  const NotificationsTabButton({super.key,
    required this.title,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () {
        context.read<NotificationBloc>().add(ChangeNotificationTab(index));
      },
      child: Column(
        children: [
          Text(
            title,
            style: isActive
                ? AppTextStyles.bold.copyWith(
              color: AppColors.current.primary
            )
                :  AppTextStyles.bold.copyWith(
                color: AppColors.current.lightText
            )
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 40,
              color:AppColors.current.primary,
            ),
        ],
      ),
    );
  }
}