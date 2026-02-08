import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/entities/comments_entity.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';

@injectable
class AddCommentUseCase {
  final HomeDomainRepository repository;

  AddCommentUseCase(this.repository);

  Future<Either<Failure, void>> call(CommentEntity comment,int postId, int? parentCommentId,) {
    return repository.addComment(comment,postId,parentCommentId);
  }
}
