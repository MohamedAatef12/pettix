import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';

@injectable
class AddPostUseCase {
  final HomeDomainRepository repository;

  AddPostUseCase(this.repository);

  Future<Either<Failure, void>> call(PostEntity post) {
    return repository.addPost(post);
  }
}
