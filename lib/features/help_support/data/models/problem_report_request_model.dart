import 'package:pettix/features/help_support/domain/entities/problem_report_entity.dart';

class ProblemReportRequestModel extends ProblemReportEntity {
  const ProblemReportRequestModel({
    required super.problemCategory,
    required super.problemTitle,
    required super.description,
    required super.stepsToReproduce,
  });

  Map<String, dynamic> toJson() => {
    'problemCategory': problemCategory,
    'problemTitle': problemTitle,
    'description': description,
    'stepsToReproduce': stepsToReproduce,
  };

  factory ProblemReportRequestModel.fromEntity(ProblemReportEntity entity) {
    return ProblemReportRequestModel(
      problemCategory: entity.problemCategory,
      problemTitle: entity.problemTitle,
      description: entity.description,
      stepsToReproduce: entity.stepsToReproduce,
    );
  }
}
