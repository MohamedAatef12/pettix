import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/entities/likes_entity.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';

@injectable
class LikePostUseCase {
  final HomeDomainRepository repository;

  LikePostUseCase(this.repository);

  Future<Either<Failure, LikesEntity>> call(int postId, int id, {int? creatorId}) {
    return repository.likePost(postId, id, creatorId: creatorId);
  }
}
