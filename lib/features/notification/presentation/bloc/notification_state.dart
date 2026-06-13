import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';

enum NotificationStatus { initial, loading, success, error }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<NotificationEntity> notifications;
  final String errorMessage;
  final int currentIndex;
  final Map<int, int> unreadCountsByType;
  final bool hasMore;
  final bool isPaginating;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.errorMessage = '',
    this.currentIndex = 0,
    this.unreadCountsByType = const {},
    this.hasMore = true,
    this.isPaginating = false,
  });

  int get totalUnreadCount => unreadCountsByType.values.fold(0, (sum, count) => sum + count);

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationEntity>? notifications,
    String? errorMessage,
    int? currentIndex,
    Map<int, int>? unreadCountsByType,
    bool? hasMore,
    bool? isPaginating,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      errorMessage: errorMessage ?? this.errorMessage,
      currentIndex: currentIndex ?? this.currentIndex,
      unreadCountsByType: unreadCountsByType ?? this.unreadCountsByType,
      hasMore: hasMore ?? this.hasMore,
      isPaginating: isPaginating ?? this.isPaginating,
    );
  }

  @override
  List<Object?> get props => [status, notifications, errorMessage, currentIndex, unreadCountsByType, hasMore, isPaginating];
}
