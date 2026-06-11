import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/features/help_support/domain/usecases/submit_problem_report_usecase.dart';

import 'problem_report_event.dart';
import 'problem_report_state.dart';

class ProblemReportBloc extends Bloc<ProblemReportEvent, ProblemReportState> {
  final SubmitProblemReportUseCase _submitProblemReportUseCase;

  ProblemReportBloc(this._submitProblemReportUseCase)
    : super(const ProblemReportState()) {
    on<SubmitProblemReportEvent>(_onSubmitProblemReport);
  }

  Future<void> _onSubmitProblemReport(
    SubmitProblemReportEvent event,
    Emitter<ProblemReportState> emit,
  ) async {
    emit(state.copyWith(status: ProblemReportStatus.loading));
    final result = await _submitProblemReportUseCase(event.problemReport);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProblemReportStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: ProblemReportStatus.success)),
    );
  }
}
