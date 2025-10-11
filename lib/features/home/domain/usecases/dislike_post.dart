import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';


@injectable
class UnLikePostUseCase {
  final HomeDomainRepository repository;

  UnLikePostUseCase(this.repository);

  Future<Either<Failure, void>> call(
    int postId,
  ) {
    return repository.unlikePost(
      postId,
    );
  }
}
