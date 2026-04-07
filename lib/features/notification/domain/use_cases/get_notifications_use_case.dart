import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import '../entities/notification_entity.dart';
import '../repo/notification_repo.dart';

@lazySingleton
class GetNotificationsUseCase {
  final NotificationRepo _repository;

  GetNotificationsUseCase(this._repository);

  Future<Either<Failure, List<NotificationEntity>>> call({
    required int pageIndex,
    required int pageSize,
    int? notificationTypeId,
  }) {
    return _repository.getNotifications(
      pageIndex: pageIndex,
      pageSize: pageSize,
      notificationTypeId: notificationTypeId,
    );
  }
}
