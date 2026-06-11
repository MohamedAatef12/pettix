import 'package:equatable/equatable.dart';
import 'package:pettix/features/help_support/domain/entities/problem_report_entity.dart';

abstract class ProblemReportEvent extends Equatable {
  const ProblemReportEvent();

  @override
  List<Object?> get props => [];
}

class SubmitProblemReportEvent extends ProblemReportEvent {
  final ProblemReportEntity problemReport;

  const SubmitProblemReportEvent(this.problemReport);

  @override
  List<Object?> get props => [problemReport];
}
