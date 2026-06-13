import 'package:equatable/equatable.dart';

enum FeedbackStatus { initial, loading, success, error }

class FeedbackState extends Equatable {
  final FeedbackStatus status;
  final String? errorMessage;

  const FeedbackState({
    this.status = FeedbackStatus.initial,
    this.errorMessage,
  });

  FeedbackState copyWith({
    FeedbackStatus? status,
    String? errorMessage,
  }) {
    return FeedbackState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
