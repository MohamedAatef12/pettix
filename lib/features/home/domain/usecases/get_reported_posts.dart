import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/home/domain/entities/report_entity.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';

@injectable
class GetReportedPostsUseCase {
  final HomeDomainRepository repository;

  GetReportedPostsUseCase(this.repository);

  Future<Either<Failure, List<ReportEntity>>> call(int postId) {
    return repository.reportedPosts(postId);
  }
}