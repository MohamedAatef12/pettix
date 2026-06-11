import 'package:dartz/dartz.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/help_support/domain/entities/problem_report_entity.dart';
import 'package:pettix/features/help_support/domain/repositories/help_support_repository.dart';

class SubmitProblemReportUseCase
    extends ParamUseCase<void, ProblemReportEntity> {
  final HelpSupportRepository _repository;

  SubmitProblemReportUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ProblemReportEntity param) {
    return _repository.submitProblemReport(param);
  }
}
