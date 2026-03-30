import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/repositories/auth_repository.dart';
@injectable
class ForgotPasswordUseCase {
  final AuthRepository repository;
  ForgotPasswordUseCase(this.repository);
  Future<Either<Failure,void>> call(String email) async {
    return await repository.forgotPassword(email);
  }
}