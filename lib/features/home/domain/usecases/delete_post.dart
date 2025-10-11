import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';


@injectable
class DeletePostUseCase {
  final HomeDomainRepository repository;

  DeletePostUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deletePost(id);
  }
}
