import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/features/home/domain/usecases/get_user_cached%20_data.dart';
import '../../domain/use_cases/get_conversations_use_case.dart';
import 'chat_list_event.dart';
import 'chat_list_state.dart';

@injectable
class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final GetConversationsUseCase _getConversationsUseCase;
  final GetUserDataUseCase _getUserDataUseCase;

  ChatListBloc(this._getConversationsUseCase, this._getUserDataUseCase) : super(ChatListInitial()) {
    on<GetConversationsEvent>(_onGetConversations);
  }

  Future<void> _onGetConversations(GetConversationsEvent event, Emitter<ChatListState> emit) async {
    emit(ChatListLoading());
    final result = await _getConversationsUseCase();
    final userResult = await _getUserDataUseCase();
    
    int? currentUserId;
    userResult.fold((_) {}, (user) => currentUserId = user.id);

    result.fold(
      (failure) => emit(ChatListError(failure.message)),
      (conversations) => emit(ChatListSuccess(conversations, currentUserId: currentUserId)),
    );
  }
}
