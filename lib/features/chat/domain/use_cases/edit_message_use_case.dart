import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import '../entity/message_entity.dart';
import '../repo/chat_repository.dart';

@lazySingleton
class EditMessageUseCase {
  final ChatRepository _repository;

  const EditMessageUseCase(this._repository);

  Future<Either<Failure, MessageEntity>> call({required int messageId, required String content}) {
    return _repository.editMessage(messageId, content);
  }
}
