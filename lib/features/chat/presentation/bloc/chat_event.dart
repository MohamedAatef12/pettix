import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class InitializeChatEvent extends ChatEvent {
  final int? conversationId;
  final int? otherUserId;

  const InitializeChatEvent({this.conversationId, this.otherUserId});

  @override
  List<Object?> get props => [conversationId, otherUserId];
}

class GetMessagesEvent extends ChatEvent {
  final int conversationId;
  final bool isRefresh;

  const GetMessagesEvent(this.conversationId, {this.isRefresh = false});

  @override
  List<Object?> get props => [conversationId, isRefresh];
}

class SendMessageEvent extends ChatEvent {
  final int conversationId;
  final String content;

  const SendMessageEvent({required this.conversationId, required this.content});

  @override
  List<Object?> get props => [conversationId, content];
}

class EditMessageEvent extends ChatEvent {
  final int messageId;
  final String newContent;

  const EditMessageEvent({required this.messageId, required this.newContent});

  @override
  List<Object?> get props => [messageId, newContent];
}

class DeleteMessageEvent extends ChatEvent {
  final int messageId;

  const DeleteMessageEvent(this.messageId);

  @override
  List<Object?> get props => [messageId];
}
