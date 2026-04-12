import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/network/failure.dart';
import '../../domain/entities/adoption_options_entity.dart';
import '../../domain/repositories/adoption_repository.dart';
import '../datasources/adoption_remote_data_source.dart';
import '../models/adoption_form_request_model.dart';

@LazySingleton(as: AdoptionRepository)
class AdoptionRepositoryImpl implements AdoptionRepository {
  final AdoptionRemoteDataSource _remoteDataSource;

  AdoptionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AdoptionOptionsEntity>> getAdoptionOptions() async {
    return await _remoteDataSource.getAdoptionOptions();
  }

  @override
  Future<Either<Failure, void>> submitAdoptionForm(
    AdoptionFormRequestModel request,
  ) async {
    return await _remoteDataSource.submitAdoptionForm(request);
  }
}
