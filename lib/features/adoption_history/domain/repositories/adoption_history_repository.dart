import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';

/// Abstract contract for adoption history data operations.
abstract class AdoptionHistoryRepository {
  /// Returns all adoption forms that the current user has submitted.
  Future<Either<Failure, List<AdoptionFormEntity>>> getClientForms();

  /// Returns all adoption forms submitted by others for the current user's pets.
  Future<Either<Failure, List<AdoptionFormEntity>>> getOwnerForms();

  /// Updates the status of an adoption form.
  Future<Either<Failure, void>> updateFormStatus(int id, int status);
}
