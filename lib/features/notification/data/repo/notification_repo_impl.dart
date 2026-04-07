import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/notification/domain/entities/notification_entity.dart';
import 'package:pettix/features/notification/domain/repo/notification_repo.dart';
import '../data_sources/notification_remote_data_source.dart';

@LazySingleton(as: NotificationRepo)
class NotificationRepoImpl implements NotificationRepo {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required int pageIndex,
    required int pageSize,
    int? notificationTypeId,
  }) async {
    try {
      final response = await _remoteDataSource.getNotifications(
        pageIndex: pageIndex,
        pageSize: pageSize,
        notificationTypeId: notificationTypeId,
      );

      if (response.success && response.result != null) {
        return Right(response.result!.data);
      } else {
        return Left(Failure(response.message));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead({
    required int notificationTypeId,
  }) async {
    try {
      final response = await _remoteDataSource.markAllAsRead(
        notificationTypeId: notificationTypeId,
      );

      if (response.success) {
        return const Right(null);
      } else {
        return Left(Failure(response.message));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead({
    required int id,
  }) async {
    try {
      final response = await _remoteDataSource.markAsRead(
        id: id,
      );

      if (response.success) {
        return const Right(null);
      } else {
        return Left(Failure(response.message));
      }
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
