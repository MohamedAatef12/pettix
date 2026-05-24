import 'package:equatable/equatable.dart';

class FeedbackEntity extends Equatable {
  final String feedbackType;
  final int rating;
  final String appArea;
  final String description;
  final bool followUp;

  const FeedbackEntity({
    required this.feedbackType,
    required this.rating,
    required this.appArea,
    required this.description,
    required this.followUp,
  });

  @override
  List<Object?> get props => [
        feedbackType,
        rating,
        appArea,
        description,
        followUp,
      ];
}
