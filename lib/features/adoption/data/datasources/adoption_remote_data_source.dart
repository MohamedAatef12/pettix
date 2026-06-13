import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/network/failure.dart';
import '../../../../data/network/api_services.dart';
import '../../../../data/network/constants.dart';
import '../models/adoption_form_request_model.dart';
import '../models/adoption_options_model.dart';

abstract class AdoptionRemoteDataSource {
  Future<Either<Failure, AdoptionOptionsModel>> getAdoptionOptions();
  Future<Either<Failure, void>> submitAdoptionForm(AdoptionFormRequestModel request);
}

@LazySingleton(as: AdoptionRemoteDataSource)
class AdoptionRemoteDataSourceImpl implements AdoptionRemoteDataSource {
  final ApiService _apiService;

  AdoptionRemoteDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, AdoptionOptionsModel>> getAdoptionOptions() async {
    try {
      final response = await _apiService.get(
        endPoint: Constants.adoptionOptionsEndpoint,
      );
      final resultJson = response.result as Map<String, dynamic>?;
      if (resultJson != null && response.success == true) {
        return Right(AdoptionOptionsModel.fromJson(resultJson));
      }
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> submitAdoptionForm(
    AdoptionFormRequestModel request,
  ) async {
    try {
      final response = await _apiService.post(
        endPoint: Constants.adoptionFormsEndpoint,
        data: request.toJson(),
      );
      if (response.success == true) {
        return const Right(null);
      }
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }
}
