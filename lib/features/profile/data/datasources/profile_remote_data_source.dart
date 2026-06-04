import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/api_services.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/data/models/user_model.dart';
import 'package:pettix/features/profile/data/models/update_profile_request_model.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, UserModel>> getProfile(int id);
  Future<Either<Failure, void>> updateProfile(UpdateProfileRequestModel request);
  Future<Either<Failure, void>> deleteAccount(int id);
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService _apiService;
  final ICacheManager _cacheManager;

  ProfileRemoteDataSourceImpl(this._apiService, this._cacheManager);

  @override
  Future<Either<Failure, UserModel>> getProfile(int id) async {
    try {
      final response = await _apiService.get(
        endPoint: '${Constants.contactEndpoint}/$id',
      );
      if (response.success == true) {
        final data = response.result;
        final Map<String, dynamic> json = data is List
            ? data.first as Map<String, dynamic>
            : data as Map<String, dynamic>;
        return Right(UserModel.fromJson(json));
      }
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(
    UpdateProfileRequestModel request,
  ) async {
    try {
      final response = await _apiService.put(
        endPoint: '${Constants.contactEndpoint}/${request.id}',
        data: request.toJson(),
      );
      if (response.success == true) return const Right(null);
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(int id) async {
    final token = await _cacheManager.getToken();
    try {
      final response = await _apiService.delete(
        endPoint: '${Constants.deleteAccountEndpoint}/$id',
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      );
      if (response.success == true) return const Right(null);
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }
}
