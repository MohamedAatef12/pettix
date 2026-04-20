import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';
import '../entity/conversation_entity.dart';
import '../entity/message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ConversationEntity>>> getConversations();
  Future<Either<Failure, List<ConversationEntity>>> getCachedConversations();
  Future<Either<Failure, ConversationEntity?>> findCachedConversationByUserId(int userId);
  Future<Either<Failure, ConversationEntity?>> getCachedConversationById(int id);

  Future<Either<Failure, ConversationEntity>> getConversationDetails(int id);

  Future<Either<Failure, ConversationEntity>> createPrivateConversation(int otherUserId);

  Future<Either<Failure, List<MessageEntity>>> getMessages(int conversationId, int skip, int take);
  Future<Either<Failure, List<MessageEntity>>> getCachedMessages(int conversationId);

  Future<Either<Failure, MessageEntity>> sendMessage(int conversationId, String content, {String? imagePath});

  Future<Either<Failure, MessageEntity>> editMessage(int messageId, String content);

  Future<Either<Failure, void>> deleteMessage(int messageId);
}
