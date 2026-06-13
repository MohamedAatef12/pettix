import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import '../entity/message_entity.dart';
import '../repo/chat_repository.dart';

@lazySingleton
class GetCachedMessagesUseCase {
  final ChatRepository _repository;

  const GetCachedMessagesUseCase(this._repository);

  Future<Either<Failure, List<MessageEntity>>> call(int conversationId) {
    return _repository.getCachedMessages(conversationId);
  }
}
