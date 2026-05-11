import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import '../entity/conversation_entity.dart';
import '../repo/chat_repository.dart';

@lazySingleton
class FindCachedConversationUseCase {
  final ChatRepository _repository;

  const FindCachedConversationUseCase(this._repository);

  Future<Either<Failure, ConversationEntity?>> call(int userId) {
    return _repository.findCachedConversationByUserId(userId);
  }
}
