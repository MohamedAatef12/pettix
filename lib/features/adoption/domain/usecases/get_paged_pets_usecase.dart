import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/config/usecases/base_use_case.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/adoption/domain/entities/paged_pets_params.dart';
import 'package:pettix/features/adoption/domain/repositories/adoption_browse_repository.dart';

@injectable
class GetPagedPetsUseCase
    extends ParamUseCase<PagedPetsResult, PagedPetsParams> {
  final AdoptionBrowseRepository _repository;

  GetPagedPetsUseCase(this._repository);

  @override
  Future<Either<Failure, PagedPetsResult>> call(PagedPetsParams params) =>
      _repository.getPagedPets(params);
}
