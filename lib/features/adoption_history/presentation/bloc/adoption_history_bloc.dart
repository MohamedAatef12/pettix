import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/features/adoption_history/domain/usecases/get_client_forms_usecase.dart';
import 'package:pettix/features/adoption_history/domain/usecases/get_owner_forms_usecase.dart';

import 'adoption_history_event.dart';
import 'adoption_history_state.dart';

@injectable
class AdoptionHistoryBloc
    extends Bloc<AdoptionHistoryEvent, AdoptionHistoryState> {
  final GetClientFormsUseCase _getClientForms;
  final GetOwnerFormsUseCase _getOwnerForms;

  AdoptionHistoryBloc(this._getClientForms, this._getOwnerForms)
      : super(const AdoptionHistoryState()) {
    on<FetchClientFormsEvent>(_onFetchClientForms);
    on<FetchOwnerFormsEvent>(_onFetchOwnerForms);
  }

  Future<void> _onFetchClientForms(
    FetchClientFormsEvent event,
    Emitter<AdoptionHistoryState> emit,
  ) async {
    emit(state.copyWith(clientStatus: AdoptionHistoryStatus.loading));
    final result = await _getClientForms();
    result.fold(
      (failure) => emit(state.copyWith(
        clientStatus: AdoptionHistoryStatus.error,
        clientError: failure.message,
      )),
      (forms) => emit(state.copyWith(
        clientStatus: AdoptionHistoryStatus.loaded,
        clientForms: forms,
      )),
    );
  }

  Future<void> _onFetchOwnerForms(
    FetchOwnerFormsEvent event,
    Emitter<AdoptionHistoryState> emit,
  ) async {
    emit(state.copyWith(ownerStatus: AdoptionHistoryStatus.loading));
    final result = await _getOwnerForms();
    result.fold(
      (failure) => emit(state.copyWith(
        ownerStatus: AdoptionHistoryStatus.error,
        ownerError: failure.message,
      )),
      (forms) => emit(state.copyWith(
        ownerStatus: AdoptionHistoryStatus.loaded,
        ownerForms: forms,
      )),
    );
  }
}
