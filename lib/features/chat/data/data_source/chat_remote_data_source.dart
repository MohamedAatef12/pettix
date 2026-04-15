import 'package:injectable/injectable.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/models/response_model.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/api_services.dart';

abstract class ChatRemoteDataSource {
  Future<ResponseModel> getConversations();
  Future<ResponseModel> getConversationDetails(int id);
  Future<ResponseModel> createPrivateConversation(Map<String, dynamic> body);
  Future<ResponseModel> getMessages(int conversationId, int skip, int take);
  Future<ResponseModel> sendMessage(int conversationId, Map<String, dynamic> body);
  Future<ResponseModel> editMessage(int messageId, Map<String, dynamic> body);
  Future<ResponseModel> deleteMessage(int messageId);
}

@LazySingleton(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiService _apiService;

  ChatRemoteDataSourceImpl(this._apiService);

  Future<Map<String, dynamic>> _getHeaders() async {
    final userToken = await DI.find<ICacheManager>().getToken();
    return userToken != null ? {'Authorization': 'Bearer $userToken'} : {};
  }

  @override
  Future<ResponseModel> getConversations() async {
    return await _apiService.get(
      endPoint: '/api/chat/conversations',
      headers: await _getHeaders(),
    );
  }

  @override
  Future<ResponseModel> getConversationDetails(int id) async {
    return await _apiService.get(
      endPoint: '/api/chat/conversations/$id',
      headers: await _getHeaders(),
    );
  }

  @override
  Future<ResponseModel> createPrivateConversation(Map<String, dynamic> body) async {
    return await _apiService.post(
      endPoint: '/api/chat/conversations/private',
      data: body,
      headers: await _getHeaders(),
    );
  }

  @override
  Future<ResponseModel> getMessages(int conversationId, int skip, int take) async {
    return await _apiService.get(
      endPoint: '/api/chat/messages/$conversationId',
      queryParameters: {'skip': skip, 'take': take},
      headers: await _getHeaders(),
    );
  }

  @override
  Future<ResponseModel> sendMessage(int conversationId, Map<String, dynamic> body) async {
    return await _apiService.post(
      endPoint: '/api/chat/messages/$conversationId',
      data: body,
      headers: await _getHeaders(),
    );
  }

  @override
  Future<ResponseModel> editMessage(int messageId, Map<String, dynamic> body) async {
    return await _apiService.put(
      endPoint: '/api/chat/messages/$messageId',
      data: body,
      headers: await _getHeaders(),
    );
  }

  @override
  Future<ResponseModel> deleteMessage(int messageId) async {
    return await _apiService.delete(
      endPoint: '/api/chat/messages/$messageId',
      headers: await _getHeaders(),
    );
  }
}
