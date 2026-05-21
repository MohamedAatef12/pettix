import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final String title;
  final String body;
  final String senderName;
  final bool isRead;
  final DateTime date;
  final int notificationTypeId;
  final String? metadata;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.senderName,
    required this.isRead,
    required this.date,
    required this.notificationTypeId,
    this.metadata,
  });

  NotificationEntity copyWith({
    int? id,
    String? title,
    String? body,
    String? senderName,
    bool? isRead,
    DateTime? date,
    int? notificationTypeId,
    String? metadata,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      senderName: senderName ?? this.senderName,
      isRead: isRead ?? this.isRead,
      date: date ?? this.date,
      notificationTypeId: notificationTypeId ?? this.notificationTypeId,
      metadata: metadata ?? this.metadata,
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
        metadata,
      ];
}
