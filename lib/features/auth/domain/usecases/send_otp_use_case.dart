import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/repositories/auth_repository.dart';
@injectable
class SendOtpUseCase {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  Future<Either<Failure,bool>> call(String phoneNumber) async {
    return await repository.sendOtp(phoneNumber);
  }
}