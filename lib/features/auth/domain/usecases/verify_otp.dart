import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/repositories/auth_repository.dart';
@injectable
class VerifyOtp {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  Future<Either<Failure,bool>> call(String phoneNumber, String code) async {
    return await repository.verifyOtp(phoneNumber,code);
  }
}