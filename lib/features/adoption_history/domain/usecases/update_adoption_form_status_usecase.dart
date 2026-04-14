import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/adoption_history/domain/repositories/adoption_history_repository.dart';

@injectable
class UpdateAdoptionFormStatusUseCase {
  final AdoptionHistoryRepository _repository;

  UpdateAdoptionFormStatusUseCase(this._repository);

  Future<Either<Failure, void>> call(int id, int status) =>
      _repository.updateFormStatus(id, status);
}
