import 'package:pettix/data/network/constants.dart';

import '../../domain/entity/message_entity.dart';
import '../../domain/entity/chat_user_entity.dart';
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
    super.isSending = false,
    super.sender,
    super.imageUrl,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: int.tryParse((json['id'] ?? json['Id'])?.toString() ?? '') ?? 0,
      conversationId: int.tryParse((json['conversationId'] ?? json['ConversationId'] ?? json['chatId'] ?? json['ChatId'] ?? json['roomId'] ?? json['RoomId'])?.toString() ?? '') ?? 0,
      senderId: int.tryParse((json['senderUserId'] ?? json['SenderUserId'] ?? json['senderId'] ?? json['SenderId'])?.toString() ?? '') ?? 0,
      content: json['messageText'] ?? json['MessageText'] ?? json['content'] ?? json['Content'] ?? '',
      sentAt: DateTime.tryParse((json['createdAt'] ?? json['CreatedAt'] ?? json['sentAt'] ?? json['SentAt'])?.toString() ?? '') ?? DateTime.now(),
      editedAt: (json['updatedAt'] ?? json['UpdatedAt']) != null ? DateTime.tryParse((json['updatedAt'] ?? json['UpdatedAt']).toString()) : ((json['editedAt'] ?? json['EditedAt']) != null ? DateTime.tryParse((json['editedAt'] ?? json['EditedAt']).toString()) : null),
      isDeleted: json['deleted'] ?? json['Deleted'] ?? json['isDeleted'] ?? json['IsDeleted'] ?? false,
      isSending: false, // Messages from backend are never "sending"
      sender: (json['sender'] ?? json['Sender']) != null ? ChatUserModel.fromJson(json['sender'] ?? json['Sender']) : null,
      imageUrl: _processImageUrl(json['imageUrl'] ?? json['ImageUrl'] ?? json['mediaUrl'] ?? json['MediaUrl'] ?? json['attachmentUrl'] ?? json['AttachmentUrl']),
    );
  }

  static String? _processImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http')) return url;
    if (url.startsWith('/')) {
      return '${Constants.baseUrl}$url';
    }
    return '${Constants.baseUrl}/$url';
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
      'imageUrl': imageUrl,
    };
  }

  @override
  MessageModel copyWith({
    int? id,
    int? conversationId,
    int? senderId,
    String? content,
    DateTime? sentAt,
    DateTime? editedAt,
    bool? isDeleted,
    bool? isSending,
    bool? isFailed,
    ChatUserEntity? sender,
    String? imageUrl,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
      editedAt: editedAt ?? this.editedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      isSending: isSending ?? this.isSending,
      sender: sender ?? this.sender,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
