import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';
import 'package:pettix/features/adoption_history/domain/repositories/adoption_history_repository.dart';

/// Returns all adoption forms submitted by others on the current user's pets.
@injectable
class GetOwnerFormsUseCase extends NoParamUseCase<List<AdoptionFormEntity>> {
  final AdoptionHistoryRepository _repository;

  GetOwnerFormsUseCase(this._repository);

  @override
  Future<Either<Failure, List<AdoptionFormEntity>>> call() =>
      _repository.getOwnerForms();
}
