import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  final int currentIndex;

  const NotificationState({this.currentIndex = 0});

  NotificationState copyWith({int? currentIndex}) {
    return NotificationState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object?> get props => [currentIndex];
}
