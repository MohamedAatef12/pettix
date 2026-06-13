import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import '../entity/conversation_entity.dart';
import '../repo/chat_repository.dart';

@lazySingleton
class GetCachedConversationByIdUseCase {
  final ChatRepository _repository;

  const GetCachedConversationByIdUseCase(this._repository);

  Future<Either<Failure, ConversationEntity?>> call(int id) {
    return _repository.getCachedConversationById(id);
  }
}
