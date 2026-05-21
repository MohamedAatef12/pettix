import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/entities/report_reason_entity.dart';
import 'package:pettix/features/adoption/domain/repositories/adoption_browse_repository.dart';

@injectable
class GetPetReportReasonsUseCase extends NoParamUseCase<List<ReportReasonEntity>> {
  final AdoptionBrowseRepository _repository;

  GetPetReportReasonsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ReportReasonEntity>>> call() =>
      _repository.getPetReportReasons();
}
