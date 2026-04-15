import '../../domain/entity/message_entity.dart';
import 'chat_user_model.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.conversationId,
    required super.senderId,
    required super.content,
    required super.sentAt,
    super.editedAt,
    super.isDeleted = false,
    super.sender,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? 0,
      conversationId: json['conversationId'] ?? 0,
      senderId: json['senderUserId'] ?? json['senderId'] ?? 0,
      content: json['messageText'] ?? json['content'] ?? '',
      sentAt: DateTime.tryParse(json['createdAt'] ?? json['sentAt'] ?? '') ?? DateTime.now(),
      editedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : (json['editedAt'] != null ? DateTime.tryParse(json['editedAt']) : null),
      isDeleted: json['deleted'] ?? json['isDeleted'] ?? false,
      sender: json['sender'] != null ? ChatUserModel.fromJson(json['sender']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'content': content,
      'sentAt': sentAt.toIso8601String(),
      'editedAt': editedAt?.toIso8601String(),
      'isDeleted': isDeleted,
      if (sender != null) 'sender': (sender as ChatUserModel).toJson(),
    };
  }
}
