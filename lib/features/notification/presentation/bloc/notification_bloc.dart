import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/use_cases/get_notifications_use_case.dart';
import '../../domain/use_cases/mark_all_notifications_as_read_use_case.dart';
import '../../domain/use_cases/mark_notification_as_read_use_case.dart';
import 'notification_event.dart';
import 'notification_state.dart';

@injectable
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
      emit(state.copyWith(status: NotificationStatus.loading));

      final result = await _getNotificationsUseCase.call(
        pageIndex: event.pageIndex,
        pageSize: event.pageSize,
        notificationTypeId: event.notificationTypeId,
      );

      result.fold(
        (failure) => emit(state.copyWith(
          status: NotificationStatus.error,
          errorMessage: failure.message,
        )),
        (notifications) => emit(state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
        )),
      );
    });

    on<ChangeNotificationTab>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });

    on<MarkAllAsReadEvent>((event, emit) async {
      final oldNotifications = [...state.notifications];

      // Optimistically update UI
      final updatedNotifications = state.notifications.map((n) {
        if (n.notificationTypeId == event.notificationTypeId) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      emit(state.copyWith(notifications: updatedNotifications));

      // API call in background
      final result = await _markAllNotificationsAsReadUseCase.call(
        notificationTypeId: event.notificationTypeId,
      );

      result.fold(
        (failure) {
          // Revert on failure
          emit(state.copyWith(
            notifications: oldNotifications,
            errorMessage: failure.message,
          ));
        },
        (_) => null, // Keep updated state
      );
    });

    on<MarkAsReadEvent>((event, emit) async {
      final oldNotifications = [...state.notifications];

      // Optimistically update UI
      final updatedNotifications = state.notifications.map((n) {
        if (n.id == event.id) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      emit(state.copyWith(notifications: updatedNotifications));

      // API call in background
      final result = await _markNotificationAsReadUseCase.call(id: event.id);

      result.fold(
        (failure) {
          // Revert on failure
          emit(state.copyWith(
            notifications: oldNotifications,
            errorMessage: failure.message,
          ));
        },
        (_) => null, // Keep updated state
      );
    });
  }
}
