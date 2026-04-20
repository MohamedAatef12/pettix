import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/core/services/signalr_service.dart';
import 'package:pettix/features/chat/domain/entity/message_entity.dart';
import 'package:pettix/features/chat/domain/use_cases/create_private_conversation_use_case.dart';
import 'package:pettix/features/chat/domain/use_cases/get_messages_use_case.dart';
import 'package:pettix/features/chat/domain/use_cases/send_message_use_case.dart';
import 'package:pettix/features/home/domain/usecases/get_user_cached%20_data.dart';
import '../../domain/use_cases/delete_message_use_case.dart';
import '../../domain/use_cases/edit_message_use_case.dart';
import '../../domain/use_cases/get_messages_use_case.dart';
import '../../domain/use_cases/get_cached_messages_use_case.dart';
import '../../domain/use_cases/find_cached_conversation_use_case.dart';
import '../../domain/use_cases/get_conversation_details_use_case.dart';
import '../../domain/use_cases/get_cached_conversation_by_id_use_case.dart';
import 'chat_event.dart';
import 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final GetCachedMessagesUseCase _getCachedMessagesUseCase;
  final FindCachedConversationUseCase _findCachedConversationUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final EditMessageUseCase _editMessageUseCase;
  final DeleteMessageUseCase _deleteMessageUseCase;
  final CreatePrivateConversationUseCase _createPrivateConversationUseCase;
  final GetConversationDetailsUseCase _getConversationDetailsUseCase;
  final GetCachedConversationByIdUseCase _getCachedConversationByIdUseCase;
  final GetUserDataUseCase _getUserDataUseCase;
  final SignalRService _signalRService;

  StreamSubscription? _messageSubscription;
  StreamSubscription? _deleteSubscription;

  static const int _pageSize = 20;

  ChatBloc(
    this._getMessagesUseCase,
    this._getCachedMessagesUseCase,
    this._findCachedConversationUseCase,
    this._sendMessageUseCase,
    this._editMessageUseCase,
    this._deleteMessageUseCase,
    this._createPrivateConversationUseCase,
    this._getConversationDetailsUseCase,
    this._getCachedConversationByIdUseCase,
    this._getUserDataUseCase,
    this._signalRService,
  ) : super(const ChatState(
          messages: [],
          status: ChatStatus.initial,
          hasMore: true,
        )) {
    on<InitializeChatEvent>(_onInitializeChat);
    on<GetMessagesEvent>(_onGetMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<EditMessageEvent>(_onEditMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
    on<OnMessageReceivedEvent>(_onMessageReceived);
    on<OnMessageDeletedEvent>(_onMessageDeleted);
  }

  Future<void> _onInitializeChat(InitializeChatEvent event, Emitter<ChatState> emit) async {
    // 1. Initial status
    emit(state.copyWith(status: ChatStatus.loading, conversationId: event.conversationId));

    // Fetch user info for isMe check
    final userResult = await _getUserDataUseCase();
    int? currentUserId;
    userResult.fold((_) {}, (user) => currentUserId = user.id);
    emit(state.copyWith(currentUserId: currentUserId));

    int? finalConvId = event.conversationId;
    bool messagesPreLoaded = false; // tracks if GetMessagesEvent was already dispatched

    // 2. If we only have otherUserId, try to find the cached conversation ID first
    if (finalConvId == null && event.otherUserId != null) {
      final cacheLookup = await _findCachedConversationUseCase(event.otherUserId!);
      cacheLookup.fold((_) {}, (convo) {
        if (convo != null) {
          finalConvId = convo.id;
          emit(state.copyWith(conversation: convo, conversationId: finalConvId));
          // Pre-load cached messages immediately while remote initialization happens
          add(GetMessagesEvent(finalConvId!, isRefresh: true));
          messagesPreLoaded = true;
        }
      });
    } else if (finalConvId != null) {
       // Pre-load cached messages (cache-first) immediately
       add(GetMessagesEvent(finalConvId!, isRefresh: true));
       messagesPreLoaded = true;
    }

    // 3. Perform remote initialization
    if (finalConvId == null && event.otherUserId != null) {
      final result = await _createPrivateConversationUseCase(event.otherUserId!);
      result.fold(
        (failure) {
          if (state.conversation == null) {
             emit(state.copyWith(status: ChatStatus.error, errorMessage: failure.message));
          }
        },
        (conversation) {
          finalConvId = conversation.id;
          emit(state.copyWith(conversation: conversation, conversationId: finalConvId));
        },
      );
    } else if (finalConvId != null) {
      // Look up cached conversation details first to skip API call if possible
      bool skippedRemoteConv = false;
      final cachedConvResult = await _getCachedConversationByIdUseCase(finalConvId!);
      cachedConvResult.fold((_) {}, (convo) {
        if (convo != null) {
           emit(state.copyWith(conversation: convo));
           skippedRemoteConv = true; // We got the details from cache, skip the remote endpoint
        }
      });

      if (!skippedRemoteConv) {
         final result = await _getConversationDetailsUseCase(finalConvId!);
         result.fold(
           (_) {},
           (conversation) => emit(state.copyWith(conversation: conversation)),
         );
      }
    }

    // 4. Setup SignalR and fetch messages (if not already fetched by GetMessagesEvent)
    if (finalConvId != null) {
      _messageSubscription?.cancel();
      _messageSubscription = _signalRService.messageStream.listen((message) {
        if (message.conversationId == finalConvId) {
          add(OnMessageReceivedEvent(message));
        }
      });

      _deleteSubscription?.cancel();
      _deleteSubscription = _signalRService.deleteStream.listen((messageId) {
        add(OnMessageDeletedEvent(messageId));
      });

      // Only dispatch if not already pre-loaded (avoids the double API call)
      if (!messagesPreLoaded) {
        add(GetMessagesEvent(finalConvId!, isRefresh: true));
      }
    } else if (event.otherUserId == null) {
      emit(state.copyWith(status: ChatStatus.error, errorMessage: 'No conversation or user ID provided'));
    }
  }

  Future<void> _onGetMessages(GetMessagesEvent event, Emitter<ChatState> emit) async {
    if (event.isRefresh) {
      // 1. Try to load from Cache first for instant feedback
      final cacheResult = await _getCachedMessagesUseCase(event.conversationId);
      cacheResult.fold(
        (_) {},
        (messages) {
          if (messages.isNotEmpty) {
            // Cache stores newest-first (appendMessage inserts at 0),
            // ensure sorted newest→oldest so index 0 = bottom of reversed list
            final sorted = List<MessageEntity>.from(messages)
              ..sort((a, b) => b.sentAt.compareTo(a.sentAt));
            emit(state.copyWith(
              status: ChatStatus.success,
              messages: sorted,
              hasMore: true,
            ));
          }
        },
      );

      // 2. Only show full spinner if cache gave us nothing
      if (state.messages.isEmpty) {
        emit(state.copyWith(status: ChatStatus.loading, hasMore: true));
      }
      // If we have cache data, stay in success state — remote data will silently update
    } else {
      if (!state.hasMore || state.status == ChatStatus.paginating) return;
      emit(state.copyWith(status: ChatStatus.paginating));
    }


    final skip = event.isRefresh ? 0 : state.messages.length;

    final result = await _getMessagesUseCase(
      conversationId: event.conversationId,
      skip: skip,
      take: _pageSize,
    );

    result.fold(
      (failure) {
        if (state.messages.isEmpty) {
          emit(state.copyWith(
            status: ChatStatus.error,
            errorMessage: failure.message,
          ));
        }
      },
      (messages) {
        final newestFirst = messages.reversed.toList();
        final newMessages = event.isRefresh ? newestFirst : [...state.messages, ...newestFirst];
        
        emit(state.copyWith(
          status: ChatStatus.success,
          messages: newMessages,
          hasMore: messages.length == _pageSize,
        ));
      },
    );
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    // 1. Optimistic UI: Add the message to the list immediately with 'isSending' status
    final optimisticMessage = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch, // temporary ID
      conversationId: event.conversationId,
      senderId: state.currentUserId ?? 0,
      content: event.content,
      sentAt: DateTime.now(),
      isSending: true,
      imageUrl: event.imagePath, // 🔹 Use local path for optimistic preview
    );

    final updatedMessages = [optimisticMessage, ...state.messages];
    emit(state.copyWith(messages: updatedMessages));

    final result = await _sendMessageUseCase(
      conversationId: event.conversationId,
      content: event.content,
      imagePath: event.imagePath,
    );

    result.fold(
      (failure) {
        // Remove the optimistic message on failure
        final updatedMessages = state.messages.where((m) => m.id != optimisticMessage.id).toList();
        emit(state.copyWith(
          status: ChatStatus.error,
          errorMessage: failure.message,
          messages: updatedMessages,
        ));
      },
      (message) {
        // Check if SignalR already added this message (race condition)
        final isAlreadyPresent = state.messages.any((m) => m.id == message.id);
        
        // Remove the optimistic message and add the real one (or just remove if already present)
        final updatedMessages = state.messages.where((m) => m.id != optimisticMessage.id).toList();
        
        if (isAlreadyPresent) {
          emit(state.copyWith(
            status: ChatStatus.success,
            messages: updatedMessages,
          ));
        } else {
          emit(state.copyWith(
            status: ChatStatus.success,
            messages: [message, ...updatedMessages],
          ));
        }
      },
    );
  }

  Future<void> _onEditMessage(EditMessageEvent event, Emitter<ChatState> emit) async {
    final result = await _editMessageUseCase(
      messageId: event.messageId,
      content: event.newContent,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      )),
      (updatedMessage) {
        final messages = state.messages.map((m) {
          return m.id == event.messageId ? updatedMessage : m;
        }).toList();
        
        emit(state.copyWith(
          status: ChatStatus.success,
          messages: messages,
        ));
      },
    );
  }

  Future<void> _onDeleteMessage(DeleteMessageEvent event, Emitter<ChatState> emit) async {
    final result = await _deleteMessageUseCase(event.messageId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      )),
      (_) {
        final messages = state.messages.map((m) {
          return m.id == event.messageId ? m.copyWith(isDeleted: true) : m;
        }).toList();

        emit(state.copyWith(
          status: ChatStatus.success,
          messages: messages,
        ));
      },
    );
  }

  void _onMessageReceived(OnMessageReceivedEvent event, Emitter<ChatState> emit) {
    // Check for duplicates (handles both local optimistic UI and multi-device sync)
    final isDuplicate = state.messages.any((m) => m.id == event.message.id);
    
    if (isDuplicate) {
      return;
    }

    emit(state.copyWith(
      messages: [event.message, ...state.messages],
    ));
  }

  void _onMessageDeleted(OnMessageDeletedEvent event, Emitter<ChatState> emit) {
    final messages = state.messages.map((m) {
      return m.id == event.messageId ? m.copyWith(isDeleted: true) : m;
    }).toList();

    emit(state.copyWith(messages: messages));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _deleteSubscription?.cancel();
    return super.close();
  }
}
