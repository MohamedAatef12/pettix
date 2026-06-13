import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/adoption/domain/entities/paged_pets_params.dart';

import 'package:pettix/features/home/domain/entities/report_reason_entity.dart';

abstract class AdoptionBrowseRepository {
  Future<Either<Failure, PagedPetsResult>> getPagedPets(PagedPetsParams params);
  Future<Either<Failure, List<ReportReasonEntity>>> getPetReportReasons();
  Future<Either<Failure, void>> reportPet(int petId, int reasonId, String customReason);
}
