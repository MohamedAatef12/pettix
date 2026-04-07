import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import '../repo/notification_repo.dart';

@lazySingleton
class MarkAllNotificationsAsReadUseCase {
  final NotificationRepo _repository;

  MarkAllNotificationsAsReadUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required int notificationTypeId,
  }) {
    return _repository.markAllAsRead(
      notificationTypeId: notificationTypeId,
    );
  }
}
