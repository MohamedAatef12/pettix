import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/features/help_support/domain/usecases/submit_feedback_usecase.dart';

import 'feedback_event.dart';
import 'feedback_state.dart';

@injectable
class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final SubmitFeedbackUseCase _submitFeedbackUseCase;

  FeedbackBloc(this._submitFeedbackUseCase) : super(const FeedbackState()) {
    on<SubmitFeedbackEvent>(_onSubmitFeedback);
  }

  Future<void> _onSubmitFeedback(
    SubmitFeedbackEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(state.copyWith(status: FeedbackStatus.loading));
    final result = await _submitFeedbackUseCase(event.feedback);
    result.fold(
      (failure) => emit(state.copyWith(
        status: FeedbackStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: FeedbackStatus.success)),
    );
  }
}
