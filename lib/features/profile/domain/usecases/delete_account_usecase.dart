import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/profile/domain/repositories/profile_repository.dart';

@injectable
class DeleteAccountUseCase extends ParamUseCase<void, int> {
  final ProfileRepository _repository;

  DeleteAccountUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(int id) =>
      _repository.deleteAccount(id);
}
