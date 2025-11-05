import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';

@injectable
class UnLikeCommentUseCase {
  final HomeDomainRepository repository;

  UnLikeCommentUseCase(this.repository);

  Future<Either<Failure, void>> call(int commentId) {
    return repository.unlikeComment(commentId);
  }
}
