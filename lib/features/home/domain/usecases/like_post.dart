import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';

@injectable
class LikePostUseCase {
  final HomeDomainRepository repository;

  LikePostUseCase(this.repository);

  Future<Either<Failure, void>> call(int postId, int id) {
    return repository.likePost(postId, id);
  }
}
