import 'package:equatable/equatable.dart';

abstract class AdoptionHistoryEvent extends Equatable {
  const AdoptionHistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Loads adoption forms the current user submitted.
class FetchClientFormsEvent extends AdoptionHistoryEvent {
  const FetchClientFormsEvent();
}

/// Loads adoption forms submitted by others on the current user's pets.
class FetchOwnerFormsEvent extends AdoptionHistoryEvent {
  const FetchOwnerFormsEvent();
}

/// Updates the status of a specific adoption form.
class UpdateFormStatusEvent extends AdoptionHistoryEvent {
  final int formId;
  final int status;

  const UpdateFormStatusEvent({required this.formId, required this.status});

  @override
  List<Object?> get props => [formId, status];
}
