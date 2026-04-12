import 'package:equatable/equatable.dart';
import 'package:pettix/features/my_pets/domain/entities/lookup_entity.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

enum AdoptionBrowseStatus { initial, loading, loaded, loadingMore, error }

class AdoptionBrowseState extends Equatable {
  final AdoptionBrowseStatus status;
  final List<PetEntity> pets;
  final int totalCount;
  final int currentPage;
  final bool hasMore;

  // Active filters
  final String? searchQuery;
  final int? selectedCategoryId;
  final int? selectedGenderId;
  final String? sortBy;
  final bool sortDescending;

  // Lookup data for filter chips
  final List<LookupEntity> categories;

  final String? errorMessage;

  const AdoptionBrowseState({
    this.status = AdoptionBrowseStatus.initial,
    this.pets = const [],
    this.totalCount = 0,
    this.currentPage = 0,
    this.hasMore = true,
    this.searchQuery,
    this.selectedCategoryId,
    this.selectedGenderId,
    this.sortBy,
    this.sortDescending = false,
    this.categories = const [],
    this.errorMessage,
  });

  bool get hasActiveFilters =>
      selectedCategoryId != null ||
      selectedGenderId != null ||
      (searchQuery != null && searchQuery!.isNotEmpty) ||
      sortBy != null;

  AdoptionBrowseState copyWith({
    AdoptionBrowseStatus? status,
    List<PetEntity>? pets,
    int? totalCount,
    int? currentPage,
    bool? hasMore,
    String? searchQuery,
    int? selectedCategoryId,
    int? selectedGenderId,
    String? sortBy,
    bool? sortDescending,
    List<LookupEntity>? categories,
    String? errorMessage,
    bool clearCategory = false,
    bool clearGender = false,
    bool clearSearch = false,
    bool clearSort = false,
  }) {
    return AdoptionBrowseState(
      status: status ?? this.status,
      pets: pets ?? this.pets,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      selectedCategoryId:
          clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      selectedGenderId:
          clearGender ? null : (selectedGenderId ?? this.selectedGenderId),
      sortBy: clearSort ? null : (sortBy ?? this.sortBy),
      sortDescending: sortDescending ?? this.sortDescending,
      categories: categories ?? this.categories,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        pets,
        totalCount,
        currentPage,
        hasMore,
        searchQuery,
        selectedCategoryId,
        selectedGenderId,
        sortBy,
        sortDescending,
        categories,
        errorMessage,
      ];
}
