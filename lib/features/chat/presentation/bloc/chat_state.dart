import 'package:equatable/equatable.dart';
import '../../domain/entity/message_entity.dart';
import '../../domain/entity/conversation_entity.dart';

enum ChatStatus { initial, loading, success, error, paginating, sending }

class ChatState extends Equatable {
  final ChatStatus status;
  final int? conversationId;
  final int? currentUserId;
  final ConversationEntity? conversation;
  final List<MessageEntity> messages;
  final String errorMessage;
  final bool hasMore;

  const ChatState({
    this.status = ChatStatus.initial,
    this.conversationId,
    this.currentUserId,
    this.conversation,
    this.messages = const [],
    this.errorMessage = '',
    this.hasMore = true,
  });

  ChatState copyWith({
    ChatStatus? status,
    int? conversationId,
    int? currentUserId,
    ConversationEntity? conversation,
    List<MessageEntity>? messages,
    String? errorMessage,
    bool? hasMore,
  }) {
    return ChatState(
      status: status ?? this.status,
      conversationId: conversationId ?? this.conversationId,
      currentUserId: currentUserId ?? this.currentUserId,
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [status, conversationId, currentUserId, conversation, messages, errorMessage, hasMore];
}
