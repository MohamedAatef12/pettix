import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/entities/report_reason_entity.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';

@injectable
class GetReportReasonsUseCase {
  final HomeDomainRepository repository;

  GetReportReasonsUseCase(this.repository);

  Future<Either<Failure, List<ReportReasonEntity>>> call() {
    return repository.getReportReasons();
  }
}