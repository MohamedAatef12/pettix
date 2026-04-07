import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final String title;
  final String body;
  final String senderName;
  final bool isRead;
  final DateTime date;
  final int notificationTypeId;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.senderName,
    required this.isRead,
    required this.date,
    required this.notificationTypeId,
  });

  NotificationEntity copyWith({
    int? id,
    String? title,
    String? body,
    String? senderName,
    bool? isRead,
    DateTime? date,
    int? notificationTypeId,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      senderName: senderName ?? this.senderName,
      isRead: isRead ?? this.isRead,
      date: date ?? this.date,
      notificationTypeId: notificationTypeId ?? this.notificationTypeId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        senderName,
        isRead,
        date,
        notificationTypeId,
      ];
}
