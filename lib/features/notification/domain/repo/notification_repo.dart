import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepo {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required int pageIndex,
    required int pageSize,
    int? notificationTypeId,
  });

  Future<Either<Failure, void>> markAllAsRead({
    required int notificationTypeId,
  });

  Future<Either<Failure, void>> markAsRead({
    required int id,
  });

}
