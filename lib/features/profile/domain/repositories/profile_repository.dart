import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/profile/domain/entities/update_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getProfile(int id);
  Future<Either<Failure, void>> updateProfile(UpdateProfileEntity request);
}
