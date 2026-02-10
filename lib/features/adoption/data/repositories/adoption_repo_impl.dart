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
    try {
      final result = await _remoteDataSource.getAdoptionOptions();
      return Right(result);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitAdoptionForm(
    AdoptionFormRequestModel request,
  ) async {
    try {
      await _remoteDataSource.submitAdoptionForm(request);
      return const Right(null);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(Failure(e.toString()));
    }
  }
}
