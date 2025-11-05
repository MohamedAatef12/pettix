import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/entities/comment_like_entity.dart';
import 'package:pettix/features/home/domain/entities/likes_entity.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';


@injectable
class GetCommentLikesUseCase {
  final HomeDomainRepository repository;

  GetCommentLikesUseCase(this.repository);

  Future<Either<Failure, List<CommentLikeEntity>>> call(int commentId) {
    return repository.getCommentLikesCount(commentId);
  }
}
