import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';

@injectable
class GetPostCommentsCountsUseCase {
  final HomeDomainRepository repository;

  GetPostCommentsCountsUseCase(this.repository);

  Future<Either<Failure, int>> call(int postId) {
    return repository.getPostCommentsCount(postId);
  }
}
