import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/core/services/signalr_service.dart';
import 'package:pettix/features/chat/domain/entity/message_entity.dart';
import 'package:pettix/features/home/domain/usecases/get_user_cached%20_data.dart';
import '../../domain/entity/conversation_entity.dart';
import '../../domain/use_cases/get_conversations_use_case.dart';
import '../../domain/use_cases/get_cached_conversations_use_case.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

@injectable
class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final GetConversationsUseCase _getConversationsUseCase;
  final GetCachedConversationsUseCase _getCachedConversationsUseCase;
  final GetUserDataUseCase _getUserDataUseCase;
  final SignalRService _signalRService;
  StreamSubscription? _conversationSubscription;
  StreamSubscription? _messageSubscription;

  ChatListBloc(
    this._getConversationsUseCase,
    this._getCachedConversationsUseCase,
    this._getUserDataUseCase,
    this._signalRService,
  ) : super(ChatListInitial()) {
    on<GetConversationsEvent>(_onGetConversations);
    on<RefreshConversationsEvent>(_onRefreshConversations);
    on<SearchConversationsEvent>(_onSearch);
    on<OnMessageReceivedInListEvent>(_onMessageReceived);

    _conversationSubscription = _signalRService.conversationStream.listen((_) {
      add(const RefreshConversationsEvent());
    });

    _messageSubscription = _signalRService.messageStream.listen((message) {
      add(OnMessageReceivedInListEvent(message));
    });
  }

  void _onSearch(SearchConversationsEvent event, Emitter<ChatListState> emit) {
    if (state is ChatListSuccess) {
      final currentState = state as ChatListSuccess;
      final query = event.query.toLowerCase();

      if (query.isEmpty) {
        emit(currentState.copyWith(
          filteredConversations: currentState.allConversations,
          searchQuery: '',
        ));
      } else {
        final filtered = currentState.allConversations.where((conv) {
          final otherMemberName = conv.members
              .where((m) => m.userId != currentState.currentUserId)
              .map((m) => m.user.displayName.toLowerCase())
              .firstOrNull;
          
          return otherMemberName?.contains(query) ?? false;
        }).toList();

        emit(currentState.copyWith(
          filteredConversations: filtered,
          searchQuery: event.query,
        ));
      }
    }
  }

  Future<void> _onMessageReceived(OnMessageReceivedInListEvent event, Emitter<ChatListState> emit) async {
    if (state is ChatListSuccess) {
      final currentState = state as ChatListSuccess;
      final message = event.message as MessageEntity;
      
      final allConversations = List<ConversationEntity>.from(currentState.allConversations);
      final index = allConversations.indexWhere((c) => c.id == message.conversationId);
      
      if (index != -1) {
        final updatedConv = allConversations[index].copyWith(lastMessage: message);
        allConversations.removeAt(index);
        allConversations.insert(0, updatedConv);
        
        List<ConversationEntity> filtered = allConversations;
        if (currentState.searchQuery.isNotEmpty) {
           final query = currentState.searchQuery.toLowerCase();
           filtered = allConversations.where((conv) {
             final otherMemberName = conv.members
                 .where((m) => m.userId != currentState.currentUserId)
                 .map((m) => m.user.displayName.toLowerCase())
                 .firstOrNull;
             return otherMemberName?.contains(query) ?? false;
           }).toList();
        }

        emit(currentState.copyWith(
          allConversations: allConversations,
          filteredConversations: filtered,
        ));
      } else {
        add(const RefreshConversationsEvent());
      }
    }
  }

  Future<void> _onGetConversations(GetConversationsEvent event, Emitter<ChatListState> emit) async {
    // 1. Try to load from Cache first for instant feedback
    final cacheResult = await _getCachedConversationsUseCase();
    final userResult = await _getUserDataUseCase();
    
    int? currentUserId;
    userResult.fold((_) {}, (user) => currentUserId = user.id);

    cacheResult.fold(
      (_) {},
      (conversations) {
        if (conversations.isNotEmpty) {
          final sorted = _sortConversations(conversations);
          // Show cached data immediately, but signal we're still syncing
          emit(ChatListSuccess(
            allConversations: sorted,
            filteredConversations: sorted,
            currentUserId: currentUserId,
            isRefreshing: true, // background fetch is about to start
          ));
        }
      },
    );

    // 2. Only show full shimmer if cache was empty
    if (state is! ChatListSuccess) {
      emit(ChatListLoading());
    }
    
    final result = await _getConversationsUseCase();

    result.fold(
      (failure) {
        if (state is ChatListSuccess) {
          // Clear banner; keep cached data visible
          emit((state as ChatListSuccess).copyWith(isRefreshing: false));
        } else {
          emit(ChatListError(failure.message));
        }
      },
      (conversations) {
        final sorted = _sortConversations(conversations);
        emit(ChatListSuccess(
          allConversations: sorted,
          filteredConversations: sorted,
          currentUserId: currentUserId,
          isRefreshing: false,
        ));
      },
    );
}

  Future<void> _onRefreshConversations(RefreshConversationsEvent event, Emitter<ChatListState> emit) async {
    // Signal that a background refresh is in progress (shows banner, not shimmer)
    if (state is ChatListSuccess) {
      emit((state as ChatListSuccess).copyWith(isRefreshing: true));
    }

    final result = await _getConversationsUseCase();
    
    int? currentUserId;
    if (state is ChatListSuccess) {
      currentUserId = (state as ChatListSuccess).currentUserId;
    } else {
      final userResult = await _getUserDataUseCase();
      userResult.fold((_) {}, (user) => currentUserId = user.id);
    }

    result.fold(
      (failure) {
        // Clear refreshing flag; only emit error if we don't have data already
        if (state is ChatListSuccess) {
          emit((state as ChatListSuccess).copyWith(isRefreshing: false));
        } else {
          emit(ChatListError(failure.message));
        }
      },
      (conversations) {
        final sorted = _sortConversations(conversations);
        if (state is ChatListSuccess) {
          final currentState = state as ChatListSuccess;
          emit(currentState.copyWith(
            allConversations: sorted,
            filteredConversations: currentState.searchQuery.isEmpty 
               ? sorted 
               : sorted.where((conv) {
                  final otherMemberName = conv.members
                      .where((m) => m.userId != currentState.currentUserId)
                      .map((m) => m.user.displayName.toLowerCase())
                      .firstOrNull;
                  return otherMemberName?.contains(currentState.searchQuery.toLowerCase()) ?? false;
               }).toList(),
            isRefreshing: false,
          ));
        } else {
          emit(ChatListSuccess(
            allConversations: sorted,
            filteredConversations: sorted,
            currentUserId: currentUserId,
            isRefreshing: false,
          ));
        }
      },
    );
  }

  List<ConversationEntity> _sortConversations(List<ConversationEntity> conversations) {
    final list = List<ConversationEntity>.from(conversations);
    list.sort((a, b) {
      final aDate = a.lastMessage?.sentAt ?? a.createdAt;
      final bDate = b.lastMessage?.sentAt ?? b.createdAt;
      return bDate.compareTo(aDate);
    });
    return list;
  }

  @override
  Future<void> close() {
    _conversationSubscription?.cancel();
    _messageSubscription?.cancel();
    return super.close();
  }
}
