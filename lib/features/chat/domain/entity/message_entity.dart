import 'package:equatable/equatable.dart';
import 'chat_user_entity.dart';

class MessageEntity extends Equatable {
  final int id;
  final int conversationId;
  final int senderId;
  final String content;
  final DateTime sentAt;
  final DateTime? editedAt;
  final bool isDeleted;
  final bool isSending;
  final ChatUserEntity? sender;
  final String? imageUrl;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.sentAt,
    this.editedAt,
    this.isDeleted = false,
    this.isSending = false,
    this.sender,
    this.imageUrl,
  });

  MessageEntity copyWith({
    int? id,
    int? conversationId,
    int? senderId,
    String? content,
    DateTime? sentAt,
    DateTime? editedAt,
    bool? isDeleted,
    bool? isSending,
    ChatUserEntity? sender,
    String? imageUrl,
  }) {
    return MessageEntity(
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

  @override
  List<Object?> get props => [id, conversationId, senderId, content, sentAt, editedAt, isDeleted, isSending, sender, imageUrl];
}
