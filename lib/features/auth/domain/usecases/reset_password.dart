import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/repositories/auth_repository.dart';
@injectable
class ResetPasswordUseCase {
  final AuthRepository repository;
  ResetPasswordUseCase(this.repository);
  Future<Either<Failure,void>> call(String email, String otp, String newPassword, String confirmPassword) async {
    return await repository.resetPassword(email, otp, newPassword, confirmPassword);
  }
}