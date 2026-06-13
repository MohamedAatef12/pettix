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
  final bool isRefreshing;

  const ChatListSuccess({
    required this.allConversations,
    required this.filteredConversations,
    this.searchQuery = '',
    this.currentUserId,
    this.isRefreshing = false,
  });

  @override
  List<Object?> get props => [allConversations, filteredConversations, searchQuery, currentUserId, isRefreshing];

  ChatListSuccess copyWith({
    List<ConversationEntity>? allConversations,
    List<ConversationEntity>? filteredConversations,
    String? searchQuery,
    int? currentUserId,
    bool? isRefreshing,
  }) {
    return ChatListSuccess(
      allConversations: allConversations ?? this.allConversations,
      filteredConversations: filteredConversations ?? this.filteredConversations,
      searchQuery: searchQuery ?? this.searchQuery,
      currentUserId: currentUserId ?? this.currentUserId,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class ChatListError extends ChatListState {
  final String message;

  const ChatListError(this.message);

  @override
  List<Object?> get props => [message];
}
