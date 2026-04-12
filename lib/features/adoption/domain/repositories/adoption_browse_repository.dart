import 'package:dartz/dartz.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/adoption/domain/entities/paged_pets_params.dart';

abstract class AdoptionBrowseRepository {
  Future<Either<Failure, PagedPetsResult>> getPagedPets(PagedPetsParams params);
}
