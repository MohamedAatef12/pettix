import 'package:flutter/material.dart';
import 'package:pettix/features/notification/presentation/view/widgets/empty_notifications.dart';

class AdoptionNotifications extends StatelessWidget {
  const AdoptionNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.sizeOf(context).height*0.7,
        child: EmptyNotifications());;
  }
}
