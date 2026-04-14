import 'package:equatable/equatable.dart';

abstract class ChatListEvent extends Equatable {
  const ChatListEvent();

  @override
  List<Object?> get props => [];
}

class GetConversationsEvent extends ChatListEvent {
  const GetConversationsEvent();
}
