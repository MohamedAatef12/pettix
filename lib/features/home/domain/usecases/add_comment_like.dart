import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';

@injectable
class LikeCommentUseCase {
  final HomeDomainRepository repository;

  LikeCommentUseCase(this.repository);

  Future<Either<Failure, void>> call(int commentId) {
    return repository.likeComment(commentId);
  }
}
