import 'package:pettix/features/notification/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.senderName,
    required super.isRead,
    required super.date,
    required super.notificationTypeId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      senderName: json['senderName'] as String? ?? '',
      isRead: json['isRead'] as bool? ?? false,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now(),
      notificationTypeId: json['notificationTypeId'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'senderName': senderName,
      'isRead': isRead,
      'date': date.toIso8601String(),
      'notificationTypeId': notificationTypeId,
    };
  }
}
