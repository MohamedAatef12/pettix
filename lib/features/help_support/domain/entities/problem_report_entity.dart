import 'package:equatable/equatable.dart';

class ProblemReportEntity extends Equatable {
  final String problemCategory;
  final String problemTitle;
  final String description;
  final String stepsToReproduce;

  const ProblemReportEntity({
    required this.problemCategory,
    required this.problemTitle,
    required this.description,
    required this.stepsToReproduce,
  });

  @override
  List<Object?> get props => [
    problemCategory,
    problemTitle,
    description,
    stepsToReproduce,
  ];
}
