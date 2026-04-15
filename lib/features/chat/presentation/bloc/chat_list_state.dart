import 'package:equatable/equatable.dart';
import '../../domain/entity/conversation_entity.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object?> get props => [];
}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListSuccess extends ChatListState {
  final List<ConversationEntity> conversations;

  const ChatListSuccess(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

class ChatListError extends ChatListState {
  final String message;

  const ChatListError(this.message);

  @override
  List<Object?> get props => [message];
}
