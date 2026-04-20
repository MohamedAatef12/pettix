import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../model/conversation_model.dart';
import '../model/message_model.dart';

abstract class ChatLocalDataSource {
  Future<void> init();
  Future<void> saveConversations(List<ConversationModel> conversations);
  Future<List<ConversationModel>> getConversations();
  Future<ConversationModel?> findConversationByUserId(int userId);
  Future<void> saveMessages(int conversationId, List<MessageModel> messages);
  Future<void> appendMessage(int conversationId, MessageModel message);
  Future<List<MessageModel>> getMessages(int conversationId);
  Future<void> clearCache();
}

@LazySingleton(as: ChatLocalDataSource)
class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  static const String _conversationsBoxName = 'chat_conversations_v1';
  static const String _messagesBoxName = 'chat_messages_v1';

  Box? _convBox;
  Box? _msgBox;

  @override
  Future<void> init() async {
    _convBox = await Hive.openBox(_conversationsBoxName);
    _msgBox = await Hive.openBox(_messagesBoxName);
  }

  Future<Box> _getConvBox() async {
    if (_convBox == null || !_convBox!.isOpen) {
      _convBox = await Hive.openBox(_conversationsBoxName);
    }
    return _convBox!;
  }

  Future<Box> _getMsgBox() async {
    if (_msgBox == null || !_msgBox!.isOpen) {
      _msgBox = await Hive.openBox(_messagesBoxName);
    }
    return _msgBox!;
  }

  @override
  Future<void> saveConversations(List<ConversationModel> conversations) async {
    final box = await _getConvBox();
    final Map<int, String> data = {
      for (var c in conversations) c.id: jsonEncode(c.toJson())
    };
    await box.putAll(data);
  }

  @override
  Future<List<ConversationModel>> getConversations() async {
    final box = await _getConvBox();
    final List<ConversationModel> conversations = [];
    for (var value in box.values) {
      if (value is String) {
        conversations.add(ConversationModel.fromJson(jsonDecode(value)));
      }
    }
    return conversations;
  }

  @override
  Future<ConversationModel?> findConversationByUserId(int userId) async {
    final conversations = await getConversations();
    for (var convo in conversations) {
      // Check if any member has the target user ID
      final hasUser = convo.members.any((m) => m.user.id == userId);
      if (hasUser) return convo;
    }
    return null;
  }

  @override
  Future<void> saveMessages(int conversationId, List<MessageModel> messages) async {
    final box = await _getMsgBox();
    final List<String> data = messages.map((m) => jsonEncode(m.toJson())).toList();
    await box.put(conversationId, data);
  }

  @override
  Future<void> appendMessage(int conversationId, MessageModel message) async {
    final box = await _getMsgBox();
    final List<dynamic>? existing = box.get(conversationId);
    final List<String> updated = existing?.cast<String>() ?? [];
    
    final messageJson = jsonEncode(message.toJson());
    // Basic duplicate check by ID if available
    if (message.id != 0 && updated.any((m) {
      try {
        return jsonDecode(m)['id'] == message.id;
      } catch (_) {
        return false;
      }
    })) {
      return; 
    }

    updated.insert(0, messageJson);
    
    if (updated.length > 100) {
      updated.removeRange(100, updated.length);
    }
    
    await box.put(conversationId, updated);

    // Sync with Conversations box to update "Last Message" preview
    final convBox = await _getConvBox();
    final convJson = convBox.get(conversationId);
    if (convJson != null && convJson is String) {
      final conv = ConversationModel.fromJson(jsonDecode(convJson));
      final updatedConv = conv.copyWith(lastMessage: message);
      await convBox.put(conversationId, jsonEncode(updatedConv.toJson()));
    }
  }

  @override
  Future<List<MessageModel>> getMessages(int conversationId) async {
    final box = await _getMsgBox();
    final List<dynamic>? data = box.get(conversationId);
    if (data == null) return [];
    
    return data.map((e) => MessageModel.fromJson(jsonDecode(e as String))).toList();
  }

  @override
  Future<void> clearCache() async {
    final cBox = await _getConvBox();
    final mBox = await _getMsgBox();
    await cBox.clear();
    await mBox.clear();
    await Hive.deleteBoxFromDisk(_conversationsBoxName);
    await Hive.deleteBoxFromDisk(_messagesBoxName);
  }
}
