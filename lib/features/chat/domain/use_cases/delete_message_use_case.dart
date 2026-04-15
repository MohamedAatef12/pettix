import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import '../repo/chat_repository.dart';

@lazySingleton
class DeleteMessageUseCase {
  final ChatRepository _repository;

  const DeleteMessageUseCase(this._repository);

  Future<Either<Failure, void>> call(int messageId) {
    return _repository.deleteMessage(messageId);
  }
}
