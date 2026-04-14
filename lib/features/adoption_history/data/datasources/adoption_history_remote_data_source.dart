import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/api_services.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/adoption_history/data/models/adoption_form_model.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';

abstract class AdoptionHistoryRemoteDataSource {
  Future<Either<Failure, List<AdoptionFormEntity>>> getClientForms();
  Future<Either<Failure, List<AdoptionFormEntity>>> getOwnerForms();
  Future<Either<Failure, void>> updateFormStatus(int id, int status);
}

@LazySingleton(as: AdoptionHistoryRemoteDataSource)
class AdoptionHistoryRemoteDataSourceImpl
    implements AdoptionHistoryRemoteDataSource {
  final ApiService _apiService;

  AdoptionHistoryRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, List<AdoptionFormEntity>>> getClientForms() =>
      _fetchForms(Constants.clientFormsEndpoint);

  @override
  Future<Either<Failure, List<AdoptionFormEntity>>> getOwnerForms() =>
      _fetchForms(Constants.ownerFormsEndpoint);

  Future<Either<Failure, List<AdoptionFormEntity>>> _fetchForms(
    String endpoint,
  ) async {
    try {
      final response = await _apiService.get(endPoint: endpoint);
      if (response.success == true) {
        final raw = response.result;
        final list = raw is List ? raw : <dynamic>[];
        return Right(
          list
              .map((e) => AdoptionFormModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateFormStatus(int id, int status) async {
    try {
      final response = await _apiService.patch(
        endPoint: '${Constants.adoptionFormsEndpoint}/$id/status',
        queryParameters: {'status': status},
      );
      if (response.success == true) return const Right(null);
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }
}
