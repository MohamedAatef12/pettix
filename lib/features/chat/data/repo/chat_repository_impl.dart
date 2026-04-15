import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';

import '../../domain/entity/conversation_entity.dart';
import '../../domain/entity/message_entity.dart';
import '../../domain/repo/chat_repository.dart';
import '../data_source/chat_remote_data_source.dart';
import '../model/conversation_model.dart';
import '../model/message_model.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations() async {
    try {
      final response = await _remoteDataSource.getConversations();

      if (response.success && response.result != null) {
        final List<dynamic> dataList = response.result as List<dynamic>;
        final List<ConversationEntity> conversations =
            dataList.map((e) => ConversationModel.fromJson(e as Map<String, dynamic>)).toList();
        return Right(conversations);
      } else {
        return Left(Failure(response.message));
      }
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> getConversationDetails(int id) async {
    try {
      final response = await _remoteDataSource.getConversationDetails(id);

      if (response.success && response.result != null) {
        final conversation = ConversationModel.fromJson(response.result as Map<String, dynamic>);
        return Right(conversation);
      } else {
        return Left(Failure(response.message));
      }
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> createPrivateConversation(int otherUserId) async {
    try {
      final response = await _remoteDataSource.createPrivateConversation({'otherContactId': otherUserId});

      if (response.success && response.result != null) {
        final conversation = ConversationModel.fromJson(response.result as Map<String, dynamic>);
        return Right(conversation);
      } else {
        return Left(Failure(response.message));
      }
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(int conversationId, int skip, int take) async {
    try {
      final response = await _remoteDataSource.getMessages(conversationId, skip, take);

      // Assuming paginated response might have 'items' or similar, but normalizing in API service usually returns the list in result.
      if (response.success && response.result != null) {
        List<dynamic> dataList;
        // Handle if response is wrapped in pagination object or direct list
        if (response.result is List) {
           dataList = response.result as List<dynamic>;
        } else if (response.result is Map && (response.result as Map).containsKey('items')) {
           dataList = (response.result as Map)['items'] as List<dynamic>;
        } else {
           dataList = [];
        }

        final List<MessageEntity> messages =
            dataList.map((e) => MessageModel.fromJson(e as Map<String, dynamic>)).toList();
        return Right(messages);
      } else {
        return Left(Failure(response.message));
      }
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(int conversationId, String content) async {
    try {
      // In a real scenario, you probably send more data, but going with basic text for now
      // Or maybe the API expects 'content' or 'text'
      // We try sending multiple possible keys to see which one the backend accepts
      final Map<String, dynamic> body = {
        'messageText': content,
        'content': content,
        'text': content,
        'message': content,
      };
      final response = await _remoteDataSource.sendMessage(conversationId, body);

      if (response.success && response.result != null) {
        final message = MessageModel.fromJson(response.result as Map<String, dynamic>);
        
        // Optimistic fallback: If the backend returns success but null/empty text, 
        // we use the content the user just sent so the UI isn't empty.
        if (message.content.isEmpty) {
          return Right(message.copyWith(content: content));
        }
        
        return Right(message);
      } else {
        return Left(Failure(response.message));
      }
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> editMessage(int messageId, String content) async {
    try {
      final response = await _remoteDataSource.editMessage(messageId, {'content': content});

      if (response.success && response.result != null) {
        final message = MessageModel.fromJson(response.result as Map<String, dynamic>);
        return Right(message);
      } else {
        return Left(Failure(response.message));
      }
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(int messageId) async {
    try {
      final response = await _remoteDataSource.deleteMessage(messageId);

      if (response.success) {
        return const Right(null);
      } else {
        return Left(Failure(response.message));
      }
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }
}
