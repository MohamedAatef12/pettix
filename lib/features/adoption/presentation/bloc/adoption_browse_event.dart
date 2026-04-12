import 'package:equatable/equatable.dart';

abstract class AdoptionBrowseEvent extends Equatable {
  const AdoptionBrowseEvent();

  @override
  List<Object?> get props => [];
}

/// Initial load — fetches first page with no filters.
class InitAdoptionBrowseEvent extends AdoptionBrowseEvent {
  const InitAdoptionBrowseEvent();
}

/// Pull-to-refresh — resets to page 0 keeping current filters.
class RefreshPetsEvent extends AdoptionBrowseEvent {
  const RefreshPetsEvent();
}

/// Load the next page (infinite scroll).
class LoadMorePetsEvent extends AdoptionBrowseEvent {
  const LoadMorePetsEvent();
}

/// Debounced search by pet name.
class SearchPetsEvent extends AdoptionBrowseEvent {
  final String query;
  const SearchPetsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Filter by category ID. Pass null to clear.
class FilterByCategoryEvent extends AdoptionBrowseEvent {
  final int? categoryId;
  const FilterByCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

/// Filter by gender ID (1=Male, 2=Female). Pass null to clear.
class FilterByGenderEvent extends AdoptionBrowseEvent {
  final int? genderId;
  const FilterByGenderEvent(this.genderId);

  @override
  List<Object?> get props => [genderId];
}

/// Sort configuration.
class SortPetsEvent extends AdoptionBrowseEvent {
  final String? sortBy;
  final bool descending;
  const SortPetsEvent({this.sortBy, this.descending = false});

  @override
  List<Object?> get props => [sortBy, descending];
}

/// Reset all filters and reload.
class ResetFiltersEvent extends AdoptionBrowseEvent {
  const ResetFiltersEvent();
}
