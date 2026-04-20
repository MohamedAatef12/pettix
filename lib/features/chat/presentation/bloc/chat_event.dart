import 'package:equatable/equatable.dart';

import '../../data/model/message_model.dart';

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
  final String? imagePath;

  const SendMessageEvent({required this.conversationId, required this.content, this.imagePath});

  @override
  List<Object?> get props => [conversationId, content, imagePath];
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

class OnMessageReceivedEvent extends ChatEvent {
  final MessageModel message;
  const OnMessageReceivedEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class OnMessageDeletedEvent extends ChatEvent {
  final int messageId;
  const OnMessageDeletedEvent(this.messageId);

  @override
  List<Object?> get props => [messageId];
}
