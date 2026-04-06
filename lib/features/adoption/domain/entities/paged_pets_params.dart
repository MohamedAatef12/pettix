import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

/// Query parameters for GET /api/Adoption/Pets/paged.
class PagedPetsParams {
  final String? name;
  final int? categoryId;
  final int? genderId;
  final String? location;
  final String? sortBy;
  final bool sortDescending;
  final bool showAll;
  final int pageIndex;
  final int pageSize;

  const PagedPetsParams({
    this.name,
    this.categoryId,
    this.genderId,
    this.location,
    this.sortBy,
    this.sortDescending = false,
    this.showAll = false,
    this.pageIndex = 0,
    this.pageSize = 10,
  });

  Map<String, dynamic> toQueryParams() => {
        if (name != null && name!.isNotEmpty) 'Name': name,
        if (categoryId != null) 'CategoryId': categoryId,
        if (genderId != null) 'GenderId': genderId,
        if (location != null && location!.isNotEmpty) 'Location': location,
        if (sortBy != null && sortBy!.isNotEmpty) 'SortBy': sortBy,
        'SortDescending': sortDescending,
        'ShowAll': true,
        'PageIndex': pageIndex,
        'PageSize': pageSize,
      };

  PagedPetsParams copyWith({
    String? name,
    int? categoryId,
    int? genderId,
    String? location,
    String? sortBy,
    bool? sortDescending,
    bool? showAll,
    int? pageIndex,
    int? pageSize,
    bool clearCategory = false,
    bool clearGender = false,
    bool clearName = false,
    bool clearSort = false,
  }) =>
      PagedPetsParams(
        name: clearName ? null : (name ?? this.name),
        categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
        genderId: clearGender ? null : (genderId ?? this.genderId),
        location: location ?? this.location,
        sortBy: clearSort ? null : (sortBy ?? this.sortBy),
        sortDescending: sortDescending ?? this.sortDescending,
        showAll: showAll ?? this.showAll,
        pageIndex: pageIndex ?? this.pageIndex,
        pageSize: pageSize ?? this.pageSize,
      );
}

/// Result of a paged pets request.
class PagedPetsResult {
  final List<PetEntity> items;
  final int totalCount;

  const PagedPetsResult({required this.items, required this.totalCount});
}
