import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class ChangeNotificationTab extends NotificationEvent {
  final int index; // 0: All, 1: Read, 2: Unread

  const ChangeNotificationTab(this.index);

  @override
  List<Object?> get props => [index];
}
