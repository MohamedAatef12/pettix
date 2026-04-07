import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class GetNotificationsEvent extends NotificationEvent {
  final int pageIndex;
  final int pageSize;
  final int? notificationTypeId;

  const GetNotificationsEvent({
    this.pageIndex = 1,
    this.pageSize = 10,
    this.notificationTypeId,
  });

  @override
  List<Object?> get props => [pageIndex, pageSize, notificationTypeId];
}

class ChangeNotificationTab extends NotificationEvent {
  final int index;

  const ChangeNotificationTab(this.index);

  @override
  List<Object?> get props => [index];
}

class MarkAllAsReadEvent extends NotificationEvent {
  final int notificationTypeId;

  const MarkAllAsReadEvent(this.notificationTypeId);

  @override
  List<Object?> get props => [notificationTypeId];
}

class MarkAsReadEvent extends NotificationEvent {
  final int id;

  const MarkAsReadEvent(this.id);

  @override
  List<Object?> get props => [id];
}
