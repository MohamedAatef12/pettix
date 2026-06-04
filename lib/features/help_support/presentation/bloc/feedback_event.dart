import 'package:equatable/equatable.dart';
import 'package:pettix/features/help_support/domain/entities/feedback_entity.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object?> get props => [];
}

class SubmitFeedbackEvent extends FeedbackEvent {
  final FeedbackEntity feedback;

  const SubmitFeedbackEvent(this.feedback);

  @override
  List<Object?> get props => [feedback];
}
