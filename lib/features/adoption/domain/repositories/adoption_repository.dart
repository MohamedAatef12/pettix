import 'package:dartz/dartz.dart';
import '../../../../data/network/failure.dart';
import '../../data/models/adoption_form_request_model.dart';
import '../entities/adoption_options_entity.dart';

abstract class AdoptionRepository {
  Future<Either<Failure, AdoptionOptionsEntity>> getAdoptionOptions();
  Future<Either<Failure, void>> submitAdoptionForm(
    AdoptionFormRequestModel request,
  );
}
