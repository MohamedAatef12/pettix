import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/core/models/response_model.dart';
import 'package:pettix/data/network/api_services.dart';

abstract class ChatRemoteDataSource {
  Future<ResponseModel> getConversations();
  Future<ResponseModel> getConversationDetails(int id);
  Future<ResponseModel> createPrivateConversation(Map<String, dynamic> body);
  Future<ResponseModel> getMessages(int conversationId, int skip, int take);
  Future<ResponseModel> sendMessage(int conversationId, FormData formData);
  Future<ResponseModel> editMessage(int messageId, FormData formData);
  Future<ResponseModel> deleteMessage(int messageId);
}

@LazySingleton(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiService _apiService;

  ChatRemoteDataSourceImpl(this._apiService);

  @override
  Future<ResponseModel> getConversations() async {
    return await _apiService.get(
      endPoint: '/api/chat/conversations',
    );
  }

  @override
  Future<ResponseModel> getConversationDetails(int id) async {
    return await _apiService.get(
      endPoint: '/api/chat/conversations/$id',
    );
  }

  @override
  Future<ResponseModel> createPrivateConversation(Map<String, dynamic> body) async {
    return await _apiService.post(
      endPoint: '/api/chat/conversations/private',
      data: body,
    );
  }

  @override
  Future<ResponseModel> getMessages(int conversationId, int skip, int take) async {
    return await _apiService.get(
      endPoint: '/api/chat/messages/$conversationId',
      queryParameters: {'skip': skip, 'take': take},
    );
  }

  @override
  Future<ResponseModel> sendMessage(int conversationId, FormData formData) async {
    return await _apiService.post(
      endPoint: '/api/chat/messages/$conversationId',
      formData: formData,
    );
  }

  @override
  Future<ResponseModel> editMessage(int messageId, FormData formData) async {
    return await _apiService.put(
      endPoint: '/api/chat/messages/$messageId',
      data: formData as dynamic,
    );
  }

  @override
  Future<ResponseModel> deleteMessage(int messageId) async {
    return await _apiService.delete(
      endPoint: '/api/chat/messages/$messageId',
    );
  }
}
