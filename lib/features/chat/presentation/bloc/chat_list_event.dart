import 'package:equatable/equatable.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object?> get props => [];
}

class GetConversationsEvent extends ChatListEvent {
  const GetConversationsEvent();
}

class RefreshConversationsEvent extends ChatListEvent {
  const RefreshConversationsEvent();
}

class OnMessageReceivedInListEvent extends ChatListEvent {
  final dynamic message; // Using dynamic or MessageEntity if imported
  const OnMessageReceivedInListEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchConversationsEvent extends ChatListEvent {
  final String query;
  const SearchConversationsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
