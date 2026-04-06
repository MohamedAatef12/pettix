import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/data/network/api_services.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/data/network/failure.dart';
import 'package:pettix/features/adoption/domain/entities/paged_pets_params.dart';
import 'package:pettix/features/my_pets/data/models/pet_model.dart';

abstract class AdoptionBrowseDataSource {
  Future<Either<Failure, PagedPetsResult>> getPagedPets(PagedPetsParams params);
}

@LazySingleton(as: AdoptionBrowseDataSource)
class AdoptionBrowseDataSourceImpl implements AdoptionBrowseDataSource {
  final ApiService _apiService;

  AdoptionBrowseDataSourceImpl(this._apiService);

  @override
  Future<Either<Failure, PagedPetsResult>> getPagedPets(
      PagedPetsParams params) async {
    try {
      final response = await _apiService.get(
        endPoint: Constants.pagedPetsEndpoint,
        queryParameters: params.toQueryParams(),
      );
      if (response.success == true) {
        final raw = response.result;
        List<dynamic> itemsList;
        int total = 0;

        if (raw is Map<String, dynamic>) {
          // Wrapped paged response: { items: [...], totalCount: N }
          final items = raw['items'] ?? raw['result'] ?? [];
          itemsList = items is List ? items : [];
          total = (raw['totalCount'] as int?) ??
              (raw['total'] as int?) ??
              itemsList.length;
        } else if (raw is List) {
          itemsList = raw;
          total = raw.length;
        } else {
          itemsList = [];
        }

        final pets = itemsList
            .map((e) => PetModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return Right(PagedPetsResult(items: pets, totalCount: total));
      }
      return Left(Failure(response.message));
    } catch (e) {
      return Left(DioFailure.fromDioError(e));
    }
  }
}
