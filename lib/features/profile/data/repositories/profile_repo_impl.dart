import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:pettix/features/profile/data/models/update_profile_request_model.dart';
import 'package:pettix/features/profile/domain/entities/update_profile_entity.dart';
import 'package:pettix/features/profile/domain/repositories/profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> getProfile(int id) =>
      _remoteDataSource.getProfile(id);

  @override
  Future<Either<Failure, void>> updateProfile(
    UpdateProfileEntity request,
  ) => _remoteDataSource.updateProfile(
        UpdateProfileRequestModel.fromEntity(request),
      );
}
