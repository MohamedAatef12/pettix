import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/auth/domain/entities/register_domain_entity.dart';
import 'package:pettix/features/auth/domain/entities/user_entity.dart';
import 'package:pettix/features/home/domain/repositories/home_domain_repo.dart';


@injectable
class GetUserDataUseCase {
  final HomeDomainRepository homeDomainRepository;

  GetUserDataUseCase(this.homeDomainRepository);
  Future<Either<Failure, UserEntity>> call() =>
      homeDomainRepository.getCachedUserData();
}
