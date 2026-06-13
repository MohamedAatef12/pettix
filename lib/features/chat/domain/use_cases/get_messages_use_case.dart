import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import '../entity/message_entity.dart';
import '../repo/chat_repository.dart';

@lazySingleton
class GetMessagesUseCase {
  final ChatRepository _repository;

  const GetMessagesUseCase(this._repository);

  Future<Either<Failure, List<MessageEntity>>> call({required int conversationId, required int skip, required int take}) {
    return _repository.getMessages(conversationId, skip, take);
  }
}
