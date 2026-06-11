import 'package:equatable/equatable.dart';

enum ProblemReportStatus { initial, loading, success, error }

class ProblemReportState extends Equatable {
  final ProblemReportStatus status;
  final String? errorMessage;

  const ProblemReportState({
    this.status = ProblemReportStatus.initial,
    this.errorMessage,
  });

  ProblemReportState copyWith({
    ProblemReportStatus? status,
    String? errorMessage,
  }) {
    return ProblemReportState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
