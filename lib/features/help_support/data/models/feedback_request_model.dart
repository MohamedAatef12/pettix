import 'package:pettix/features/help_support/domain/entities/feedback_entity.dart';

class FeedbackRequestModel extends FeedbackEntity {
  const FeedbackRequestModel({
    required super.feedbackType,
    required super.rating,
    required super.appArea,
    required super.description,
    required super.followUp,
  });

  Map<String, dynamic> toJson() => {
        'feedbackType': feedbackType,
        'rating': rating,
        'appArea': appArea,
        'description': description,
        'followUp': followUp,
      };

  factory FeedbackRequestModel.fromEntity(FeedbackEntity entity) {
    return FeedbackRequestModel(
      feedbackType: entity.feedbackType,
      rating: entity.rating,
      appArea: entity.appArea,
      description: entity.description,
      followUp: entity.followUp,
    );
  }
}
