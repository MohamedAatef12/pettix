import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';

class EditPostUseCase {
  final HomeDomainRepository repository;

  EditPostUseCase(this.repository);

  Future<Either<Failure, void>> call(
    PostEntity post, {
    List<String> deletedImages = const [],
  }) {
    return repository.editPost(post, deletedImages: deletedImages);
  }
}
