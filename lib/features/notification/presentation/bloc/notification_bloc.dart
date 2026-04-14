import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/core/enums/app_enums.dart';
import 'package:pettix/features/notification/domain/entities/notification_entity.dart';
import '../../domain/use_cases/get_notifications_use_case.dart';
import '../../domain/use_cases/mark_all_notifications_as_read_use_case.dart';
import '../../domain/use_cases/mark_notification_as_read_use_case.dart';
import 'notification_event.dart';
import 'notification_state.dart';

@lazySingleton
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAllNotificationsAsReadUseCase _markAllNotificationsAsReadUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;

  NotificationBloc(
    this._getNotificationsUseCase,
    this._markAllNotificationsAsReadUseCase,
    this._markNotificationAsReadUseCase,
  ) : super(const NotificationState()) {
    on<GetNotificationsEvent>((event, emit) async {
      final isFirstPage = event.pageIndex <= 1;
      
      if (isFirstPage) {
        emit(state.copyWith(status: NotificationStatus.loading, hasMore: true));
      } else {
        emit(state.copyWith(isPaginating: true));
      }

      final result = await _getNotificationsUseCase.call(
        pageIndex: event.pageIndex,
        pageSize: event.pageSize,
        notificationTypeId: event.notificationTypeId,
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: isFirstPage ? NotificationStatus.error : state.status,
          isPaginating: false,
          errorMessage: failure.message,
        )),
        (notifications) {
          final updatedCounts = Map<int, int>.from(state.unreadCountsByType);
          if (event.notificationTypeId != null) {
            final unreadInPage = notifications.where((n) => !n.isRead).length;
            final currentKnown = updatedCounts[event.notificationTypeId!] ?? 0;

            if (unreadInPage > currentKnown || (event.pageSize ?? 10) >= 40) {
              updatedCounts[event.notificationTypeId!] = unreadInPage;
            }
          }

          final List<NotificationEntity> currentList = isFirstPage ? [] : List.from(state.notifications);
          currentList.addAll(notifications);

          emit(state.copyWith(
            status: NotificationStatus.success,
            notifications: currentList,
            unreadCountsByType: updatedCounts,
            isPaginating: false,
            hasMore: notifications.length == (event.pageSize ?? 10),
          ));
        },
      );
    });

    on<FetchAllUnreadCounts>((event, emit) async {
      // Fetch all with a larger page size to get a better count (heuristic if API doesn't support)
      final result = await _getNotificationsUseCase.call(
        pageIndex: 1,
        pageSize: 50, // Get more to find unread
      );

      result.fold(
        (_) => null,
        (notifications) {
          final counts = <int, int>{};
          for (var type in NotificationType.values) {
            counts[type.value] = notifications
                .where((n) => n.notificationTypeId == type.value && !n.isRead)
                .length;
          }
          emit(state.copyWith(unreadCountsByType: counts));
        },
      );
    });

    on<ChangeNotificationTab>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });

    on<MarkAllAsReadEvent>((event, emit) async {
      final oldNotifications = [...state.notifications];
      final oldCounts = Map<int, int>.from(state.unreadCountsByType);

      // Optimistically update UI
      final updatedNotifications = state.notifications.map((n) {
        if (n.notificationTypeId == event.notificationTypeId) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      final updatedCounts = Map<int, int>.from(state.unreadCountsByType);
      updatedCounts[event.notificationTypeId] = 0;

      emit(state.copyWith(
        notifications: updatedNotifications,
        unreadCountsByType: updatedCounts,
      ));

      // API call in background
      final result = await _markAllNotificationsAsReadUseCase.call(
        notificationTypeId: event.notificationTypeId,
      );

      result.fold(
        (failure) {
          // Revert on failure
          emit(state.copyWith(
            notifications: oldNotifications,
            unreadCountsByType: oldCounts,
            errorMessage: failure.message,
          ));
        },
        (_) => null, // Keep updated state
      );
    });

    on<MarkAsReadEvent>((event, emit) async {
      final oldNotifications = [...state.notifications];
      final oldCounts = Map<int, int>.from(state.unreadCountsByType);

      // Optimistically update UI
      NotificationEntity? target;
      final updatedNotifications = state.notifications.map((n) {
        if (n.id == event.id) {
          target = n;
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      final updatedCounts = Map<int, int>.from(state.unreadCountsByType);
      if (target != null && !target!.isRead) {
        final currentCount = updatedCounts[target!.notificationTypeId] ?? 0;
        if (currentCount > 0) {
          updatedCounts[target!.notificationTypeId] = currentCount - 1;
        }
      }

      emit(state.copyWith(
        notifications: updatedNotifications,
        unreadCountsByType: updatedCounts,
      ));

      // API call in background
      final result = await _markNotificationAsReadUseCase.call(id: event.id);

      result.fold(
        (failure) {
          // Revert on failure
          emit(state.copyWith(
            notifications: oldNotifications,
            unreadCountsByType: oldCounts,
            errorMessage: failure.message,
          ));
        },
        (_) => null, // Keep updated state
      );
    });
  }
}
