import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_states.dart';
import 'package:pettix/features/notification/presentation/view/widgets/adoption_notifications.dart';
import 'package:pettix/features/notification/presentation/view/widgets/all_notifications.dart';
import 'package:pettix/features/notification/presentation/view/widgets/empty_notifications.dart';
import 'package:pettix/features/notification/presentation/view/widgets/notifications_tab_bar.dart';
import 'package:pettix/features/notification/presentation/view/widgets/unread_notifications.dart';

class NotificationBody extends StatelessWidget {
  const NotificationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        final tabs = [
          AllNotifications(),
          const AdoptionNotifications(),
          const UnreadNotifications(),
        ];
        return Column(
          children: [
            // Tabs (buttons)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NotificationsTabButton(
                  title: "All",
                  index: 0,
                  currentIndex: state.currentIndex,
                ),
                NotificationsTabButton(
                  title: "Adoption",
                  index: 1,
                  currentIndex: state.currentIndex,
                ),
                NotificationsTabButton(
                  title: "Unread",
                  index: 2,
                  currentIndex: state.currentIndex,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(child: tabs[state.currentIndex]),
          ],
        );
      },
    );
  }
}
