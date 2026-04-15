import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/features/chat/domain/use_cases/get_messages_use_case.dart';
import 'package:pettix/features/chat/domain/use_cases/send_message_use_case.dart';
import 'package:pettix/features/home/domain/usecases/get_user_cached%20_data.dart';
import '../../domain/use_cases/delete_message_use_case.dart';
import '../../domain/use_cases/edit_message_use_case.dart';
import '../../domain/use_cases/create_private_conversation_use_case.dart';
import '../../domain/use_cases/get_conversation_details_use_case.dart';
import 'chat_event.dart';
import 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final EditMessageUseCase _editMessageUseCase;
  final DeleteMessageUseCase _deleteMessageUseCase;
  final CreatePrivateConversationUseCase _createPrivateConversationUseCase;
  final GetConversationDetailsUseCase _getConversationDetailsUseCase;
  final GetUserDataUseCase _getUserDataUseCase;

  static const int _pageSize = 20;

  ChatBloc(
    this._getMessagesUseCase,
    this._sendMessageUseCase,
    this._editMessageUseCase,
    this._deleteMessageUseCase,
    this._createPrivateConversationUseCase,
    this._getConversationDetailsUseCase,
    this._getUserDataUseCase,
  ) : super(const ChatState()) {
    on<InitializeChatEvent>(_onInitializeChat);
    on<GetMessagesEvent>(_onGetMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<EditMessageEvent>(_onEditMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
  }

  Future<void> _onInitializeChat(InitializeChatEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading, conversationId: event.conversationId));

    // Fetch user info for isMe check
    final userResult = await _getUserDataUseCase();
    int? currentUserId;
    userResult.fold((_) {}, (user) => currentUserId = user.id);
    emit(state.copyWith(currentUserId: currentUserId));

    int? finalConvId = event.conversationId;

    if (finalConvId == null && event.otherUserId != null) {
      final result = await _createPrivateConversationUseCase(event.otherUserId!);
      
      final res = result.fold(
        (failure) {
          emit(state.copyWith(status: ChatStatus.error, errorMessage: failure.message));
          return null;
        },
        (conversation) {
          emit(state.copyWith(conversationId: conversation.id, conversation: conversation));
          return conversation.id;
        },
      );
      
      if (res == null) return;
      finalConvId = res;
    } else if (finalConvId != null) {
      // Fetch conversation details if we have an ID
      final result = await _getConversationDetailsUseCase(finalConvId);
      result.fold(
        (_) {},
        (conversation) => emit(state.copyWith(conversation: conversation)),
      );
    }

    if (finalConvId != null) {
      add(GetMessagesEvent(finalConvId, isRefresh: true));
    } else {
      emit(state.copyWith(status: ChatStatus.error, errorMessage: 'No conversation or user ID provided'));
    }
  }

  Future<void> _onGetMessages(GetMessagesEvent event, Emitter<ChatState> emit) async {
    if (event.isRefresh) {
      emit(state.copyWith(status: ChatStatus.loading, hasMore: true));
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
      (failure) => emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      )),
      (messages) {
        // The API returns oldest-first, so we reverse it to maintain a newest-first list in state.
        // This works with our reverse: true ListView to show newest at the bottom.
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
    emit(state.copyWith(status: ChatStatus.sending));

    final result = await _sendMessageUseCase(
      conversationId: event.conversationId,
      content: event.content,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      )),
      (message) {
        emit(state.copyWith(
          status: ChatStatus.success,
          messages: [message, ...state.messages], // Insert at top if list is reversed
        ));
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
}
