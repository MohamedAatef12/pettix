import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/adoption/data/datasources/adoption_browse_data_source.dart';
import 'package:pettix/features/adoption/domain/entities/paged_pets_params.dart';
import 'package:pettix/features/adoption/domain/repositories/adoption_browse_repository.dart';

import 'package:pettix/features/home/domain/entities/report_reason_entity.dart';

@LazySingleton(as: AdoptionBrowseRepository)
class AdoptionBrowseRepoImpl implements AdoptionBrowseRepository {
  final AdoptionBrowseDataSource _dataSource;

  AdoptionBrowseRepoImpl(this._dataSource);

  @override
  Future<Either<Failure, PagedPetsResult>> getPagedPets(
          PagedPetsParams params) =>
      _dataSource.getPagedPets(params);

  @override
  Future<Either<Failure, List<ReportReasonEntity>>> getPetReportReasons() async {
    final result = await _dataSource.getPetReportReasons();
    return result.fold(
      (failure) => Left(failure),
      (success) {
        try {
          final reasons = success.map((reason) {
            if (reason is Map<String, dynamic>) {
              return ReportReasonEntity(
                id: reason['id'] as int,
                name: reason['name'] as String,
              );
            }
            throw FormatException('Invalid reason format: $reason');
          }).toList();
          return Right(reasons);
        } catch (e) {
          return Left(Failure('Failed to parse pet report reasons: $e'));
        }
      },
    );
  }

  @override
  Future<Either<Failure, void>> reportPet(
    int petId,
    int reasonId,
    String customReason,
  ) =>
      _dataSource.reportPet(petId, reasonId, customReason);
}
