import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import '../repo/notification_repo.dart';

@lazySingleton
class MarkNotificationAsReadUseCase {
  final NotificationRepo _repository;

  MarkNotificationAsReadUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required int id,
  }) {
    return _repository.markAsRead(
      id: id,
    );
  }
}
