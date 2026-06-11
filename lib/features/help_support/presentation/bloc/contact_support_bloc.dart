import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/features/help_support/domain/usecases/submit_contact_support_usecase.dart';

import 'contact_support_event.dart';
import 'contact_support_state.dart';

class ContactSupportBloc
    extends Bloc<ContactSupportEvent, ContactSupportState> {
  final SubmitContactSupportUseCase _submitContactSupportUseCase;

  ContactSupportBloc(this._submitContactSupportUseCase)
    : super(const ContactSupportState()) {
    on<SubmitContactSupportEvent>(_onSubmitContactSupport);
  }

  Future<void> _onSubmitContactSupport(
    SubmitContactSupportEvent event,
    Emitter<ContactSupportState> emit,
  ) async {
    emit(state.copyWith(status: ContactSupportStatus.loading));
    final result = await _submitContactSupportUseCase(event.contactSupport);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ContactSupportStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: ContactSupportStatus.success)),
    );
  }
}
