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
  final List<ConversationEntity> allConversations;
  final List<ConversationEntity> filteredConversations;
  final String searchQuery;
  final int? currentUserId;

  const ChatListSuccess({
    required this.allConversations,
    required this.filteredConversations,
    this.searchQuery = '',
    this.currentUserId,
  });

  @override
  List<Object?> get props => [allConversations, filteredConversations, searchQuery, currentUserId];

  ChatListSuccess copyWith({
    List<ConversationEntity>? allConversations,
    List<ConversationEntity>? filteredConversations,
    String? searchQuery,
    int? currentUserId,
  }) {
    return ChatListSuccess(
      allConversations: allConversations ?? this.allConversations,
      filteredConversations: filteredConversations ?? this.filteredConversations,
      searchQuery: searchQuery ?? this.searchQuery,
      currentUserId: currentUserId ?? this.currentUserId,
    );
  }
}

class ChatListError extends ChatListState {
  final String message;

  const ChatListError(this.message);

  @override
  List<Object?> get props => [message];
}
