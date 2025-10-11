import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/entities/likes_entity.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';


@injectable
class GetPostLikesUseCase {
  final HomeDomainRepository repository;

  GetPostLikesUseCase(this.repository);

  Future<Either<Failure, List<LikesEntity>>> call(int postId) {
    return repository.getPostLikes(postId);
  }
}
