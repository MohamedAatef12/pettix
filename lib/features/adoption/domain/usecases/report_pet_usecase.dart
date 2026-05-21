import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/adoption/domain/repositories/adoption_browse_repository.dart';

class ReportPetParams {
  final int petId;
  final int reasonId;
  final String customReason;

  const ReportPetParams({
    required this.petId,
    required this.reasonId,
    required this.customReason,
  });
}

@injectable
class ReportPetUseCase extends ParamUseCase<void, ReportPetParams> {
  final AdoptionBrowseRepository _repository;

  ReportPetUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ReportPetParams params) =>
      _repository.reportPet(
        params.petId,
        params.reasonId,
        params.customReason,
      );
}
