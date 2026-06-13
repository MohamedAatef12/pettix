import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';

@injectable
class GetPostByIdUseCase {
  final HomeDomainRepository repository;

  GetPostByIdUseCase(this.repository);

  Future<Either<Failure, PostEntity>> call(int id) {
    return repository.getPostById(id);
  }
}
