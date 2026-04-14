import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/use_cases/delete_message_use_case.dart';
import '../../domain/use_cases/edit_message_use_case.dart';
import '../../domain/use_cases/get_messages_use_case.dart';
import '../../domain/use_cases/send_message_use_case.dart';
import 'chat_event.dart';
import 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final EditMessageUseCase _editMessageUseCase;
  final DeleteMessageUseCase _deleteMessageUseCase;

  static const int _pageSize = 20;

  ChatBloc(
    this._getMessagesUseCase,
    this._sendMessageUseCase,
    this._editMessageUseCase,
    this._deleteMessageUseCase,
  ) : super(const ChatState()) {
    on<GetMessagesEvent>(_onGetMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<EditMessageEvent>(_onEditMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
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
        final newMessages = event.isRefresh ? messages : [...state.messages, ...messages];
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
