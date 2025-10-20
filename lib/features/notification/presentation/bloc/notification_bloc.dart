import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_events.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_states.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<ChangeNotificationTab>((event, emit) {
      emit(state.copyWith(currentIndex: event.index));
    });
  }
}
