import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/chat/data/data_source/chat_local_data_source.dart';

import '../../domain/entity/conversation_entity.dart';
import '../../domain/entity/message_entity.dart';
import '../../domain/repo/chat_repository.dart';
import '../data_source/chat_remote_data_source.dart';
import '../model/conversation_model.dart';
import '../model/message_model.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;
  final ChatLocalDataSource _localDataSource;

  ChatRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations() async {
    try {
      final response = await _remoteDataSource.getConversations();

      if (response.success && response.result != null) {
        final List<dynamic> dataList = response.result as List<dynamic>;
        final List<ConversationModel> conversations =
            dataList.map((e) => ConversationModel.fromJson(e as Map<String, dynamic>)).toList();
        
        // Save to cache
        await _localDataSource.saveConversations(conversations);
        
        return Right(conversations);
      } else {
        return Left(Failure(response.message));
      }
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getCachedConversations() async {
    try {
      final conversations = await _localDataSource.getConversations();
      return Right(conversations);
    } catch (e) {
      return Left(Failure('Failed to load cached conversations: $e'));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity?>> findCachedConversationByUserId(int userId) async {
    try {
      final conversation = await _localDataSource.findConversationByUserId(userId);
      return Right(conversation);
    } catch (e) {
      return Left(Failure('Failed to find cached conversation: $e'));
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

      if (response.success && response.result != null) {
        List<dynamic> dataList;
        if (response.result is List) {
           dataList = response.result as List<dynamic>;
        } else if (response.result is Map && (response.result as Map).containsKey('items')) {
           dataList = (response.result as Map)['items'] as List<dynamic>;
        } else {
           dataList = [];
        }

        final List<MessageModel> messages =
            dataList.map((e) => MessageModel.fromJson(e as Map<String, dynamic>)).toList();
        
        // Save to cache (only if it's the first page/refresh)
        if (skip == 0) {
          await _localDataSource.saveMessages(conversationId, messages);
        }
        
        return Right(messages);
      } else {
        return Left(Failure(response.message));
      }
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getCachedMessages(int conversationId) async {
    try {
      final messages = await _localDataSource.getMessages(conversationId);
      return Right(messages);
    } catch (e) {
      return Left(Failure('Failed to load cached messages: $e'));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(int conversationId, String content, {String? imagePath}) async {
    try {
      final Map<String, dynamic> data = {
        'MessageText': content,
      };

      if (imagePath != null) {
        data['MessageType'] = 'image';
        data['Attachment'] = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        );
      } else {
        data['MessageType'] = 'text';
      }

      final FormData formData = FormData.fromMap(data);

      final response = await _remoteDataSource.sendMessage(conversationId, formData);

      if (response.success && response.result != null) {
        var message = MessageModel.fromJson(response.result as Map<String, dynamic>);
        
        if (message.content.isEmpty) {
          message = message.copyWith(content: content) as MessageModel;
        }

        // Save to cache
        await _localDataSource.appendMessage(conversationId, message);
        
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
      final FormData formData = FormData.fromMap({
        'MessageText': content,
        'MessageType': 'text',
      });
      final response = await _remoteDataSource.editMessage(messageId, formData);

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
