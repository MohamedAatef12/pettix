import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';

@injectable
class GetPostCommentsUseCase {
  final HomeDomainRepository repository;

  GetPostCommentsUseCase(this.repository);

  Future<Either<Failure, List<CommentEntity>>> call(int postId) {
    return repository.getPostComments(postId);
  }
}
