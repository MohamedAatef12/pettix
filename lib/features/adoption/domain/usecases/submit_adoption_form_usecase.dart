import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/network/failure.dart';
import '../../data/models/adoption_form_request_model.dart';
import '../repositories/adoption_repository.dart';

@injectable
class SubmitAdoptionFormUseCase {
  final AdoptionRepository repository;

  SubmitAdoptionFormUseCase(this.repository);

  Future<Either<Failure, void>> call(AdoptionFormRequestModel request) async {
    return await repository.submitAdoptionForm(request);
  }
}
