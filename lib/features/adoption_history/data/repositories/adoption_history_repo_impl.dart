import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/adoption_history/data/datasources/adoption_history_remote_data_source.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';
import 'package:pettix/features/adoption_history/domain/repositories/adoption_history_repository.dart';

@LazySingleton(as: AdoptionHistoryRepository)
class AdoptionHistoryRepositoryImpl implements AdoptionHistoryRepository {
  final AdoptionHistoryRemoteDataSource _remoteDataSource;

  AdoptionHistoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<AdoptionFormEntity>>> getClientForms() =>
      _remoteDataSource.getClientForms();

  @override
  Future<Either<Failure, List<AdoptionFormEntity>>> getOwnerForms() =>
      _remoteDataSource.getOwnerForms();
}
