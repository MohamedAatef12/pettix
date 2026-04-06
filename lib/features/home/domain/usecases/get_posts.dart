import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';


import 'package:pettix/features/home/domain/entities/paginated_posts.dart';

@injectable
class GetPostsUseCase {
  final HomeDomainRepository repository;

  GetPostsUseCase(this.repository);

  Future<Either<Failure, PaginatedPosts>> call({int pageIndex = 1, int pageSize = 10}) {
    return repository.getPosts(pageIndex: pageIndex, pageSize: pageSize);
  }
}
