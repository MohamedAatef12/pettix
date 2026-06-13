import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import '../entity/conversation_entity.dart';
import '../repo/chat_repository.dart';

@lazySingleton
class GetConversationsUseCase {
  final ChatRepository _repository;

  const GetConversationsUseCase(this._repository);

  Future<Either<Failure, List<ConversationEntity>>> call() {
    return _repository.getConversations();
  }
}
