import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/enums/app_enums.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_state.dart';
import 'package:pettix/features/notification/presentation/view/widgets/notification_card.dart';

class AdoptionNotifications extends StatelessWidget {
  const AdoptionNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        final adoptionNotifications = state.notifications
            .where((n) => n.notificationTypeId == NotificationType.adoption.value)
            .toList();

        if (state.status == NotificationStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == NotificationStatus.error) {
          return Center(child: Text(state.errorMessage));
        }
        if (adoptionNotifications.isEmpty) {
          return const Center(child: Text("No adoption notifications"));
        }
        return ListView.builder(
            itemCount: adoptionNotifications.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return NotificationCard(
                color: AppColors.current.white,
                notification: adoptionNotifications[index],
              );
            });
      },
    );
  }
}
