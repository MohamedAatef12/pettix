import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';

@injectable
class AddReportUseCase {
  final HomeDomainRepository repository;

  AddReportUseCase(this.repository);

  Future<Either<Failure, void>> call(int postId, int reasonId, String reason) {
    return repository.reportPost(postId, reasonId, reason);
  }
}