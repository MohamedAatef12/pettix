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
