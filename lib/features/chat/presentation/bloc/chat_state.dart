import 'package:equatable/equatable.dart';
import '../../domain/entity/message_entity.dart';

enum ChatStatus { initial, loading, success, error, paginating, sending }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<MessageEntity> messages;
  final String errorMessage;
  final bool hasMore;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.errorMessage = '',
    this.hasMore = true,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<MessageEntity>? messages,
    String? errorMessage,
    bool? hasMore,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [status, messages, errorMessage, hasMore];
}
