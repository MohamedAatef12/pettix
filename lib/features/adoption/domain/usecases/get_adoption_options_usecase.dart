import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../data/network/failure.dart';
import '../entities/adoption_options_entity.dart';
import '../repositories/adoption_repository.dart';

@injectable
class GetAdoptionOptionsUseCase {
  final AdoptionRepository repository;

  GetAdoptionOptionsUseCase(this.repository);

  Future<Either<Failure, AdoptionOptionsEntity>> call() async {
    return await repository.getAdoptionOptions();
  }
}
