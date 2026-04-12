import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/adoption/data/datasources/adoption_browse_data_source.dart';
import 'package:pettix/features/adoption/domain/entities/paged_pets_params.dart';
import 'package:pettix/features/adoption/domain/repositories/adoption_browse_repository.dart';

@LazySingleton(as: AdoptionBrowseRepository)
class AdoptionBrowseRepoImpl implements AdoptionBrowseRepository {
  final AdoptionBrowseDataSource _dataSource;

  AdoptionBrowseRepoImpl(this._dataSource);

  @override
  Future<Either<Failure, PagedPetsResult>> getPagedPets(
          PagedPetsParams params) =>
      _dataSource.getPagedPets(params);
}
