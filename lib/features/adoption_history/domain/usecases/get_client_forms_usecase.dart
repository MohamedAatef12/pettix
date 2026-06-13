import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';
import 'package:pettix/features/adoption_history/domain/repositories/adoption_history_repository.dart';

/// Returns all adoption applications submitted by the current user.
@injectable
class GetClientFormsUseCase extends NoParamUseCase<List<AdoptionFormEntity>> {
  final AdoptionHistoryRepository _repository;

  GetClientFormsUseCase(this._repository);

  @override
  Future<Either<Failure, List<AdoptionFormEntity>>> call() =>
      _repository.getClientForms();
}
