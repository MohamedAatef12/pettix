import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pettix/features/adoption/domain/entities/paged_pets_params.dart';
import 'package:pettix/features/adoption/domain/usecases/get_paged_pets_usecase.dart';
import 'package:pettix/features/my_pets/domain/usecases/get_pet_options_usecase.dart';

import 'adoption_browse_event.dart';
import 'adoption_browse_state.dart';

@injectable
class AdoptionBrowseBloc
    extends Bloc<AdoptionBrowseEvent, AdoptionBrowseState> {
  final GetPagedPetsUseCase _getPagedPets;
  final GetPetOptionsUseCase _getPetOptions;

  static const int _pageSize = 10;

  AdoptionBrowseBloc(this._getPagedPets, this._getPetOptions)
      : super(const AdoptionBrowseState()) {
    on<InitAdoptionBrowseEvent>(_onInit);
    on<RefreshPetsEvent>(_onRefresh);
    on<LoadMorePetsEvent>(_onLoadMore);
    on<SearchPetsEvent>(_onSearch);
    on<FilterByCategoryEvent>(_onFilterCategory);
    on<FilterByGenderEvent>(_onFilterGender);
    on<SortPetsEvent>(_onSort);
    on<ResetFiltersEvent>(_onReset);
  }

  // ─── Helpers ────────────────────────────────────────────────────────────────

  PagedPetsParams _buildParams(AdoptionBrowseState s, {int pageIndex = 1}) =>
      PagedPetsParams(
        name: s.searchQuery,
        categoryId: s.selectedCategoryId,
        genderId: s.selectedGenderId,
        sortBy: s.sortBy,
        sortDescending: s.sortDescending,
        showAll: false,
        pageIndex: pageIndex,
        pageSize: _pageSize,
      );

  // ─── Handlers ───────────────────────────────────────────────────────────────

  Future<void> _onInit(
      InitAdoptionBrowseEvent event, Emitter<AdoptionBrowseState> emit) async {
    emit(state.copyWith(status: AdoptionBrowseStatus.loading));

    // Load categories for filter chips (best-effort — don't fail on error).
    final optResult = await _getPetOptions();
    final cats = optResult.fold((_) => state.categories, (o) => o.categories);

    final result = await _getPagedPets(_buildParams(state));
    result.fold(
      (f) => emit(state.copyWith(
          status: AdoptionBrowseStatus.error,
          errorMessage: f.message,
          categories: cats)),
      (r) => emit(state.copyWith(
        status: AdoptionBrowseStatus.loaded,
        pets: r.items,
        totalCount: r.totalCount,
        currentPage: 0,
        hasMore: r.items.length >= _pageSize,
        categories: cats,
      )),
    );
  }

  Future<void> _onRefresh(
      RefreshPetsEvent event, Emitter<AdoptionBrowseState> emit) async {
    emit(state.copyWith(status: AdoptionBrowseStatus.loading));
    final result = await _getPagedPets(_buildParams(state));
    result.fold(
      (f) => emit(state.copyWith(
          status: AdoptionBrowseStatus.error, errorMessage: f.message)),
      (r) => emit(state.copyWith(
        status: AdoptionBrowseStatus.loaded,
        pets: r.items,
        totalCount: r.totalCount,
        currentPage: 0,
        hasMore: r.items.length >= _pageSize,
      )),
    );
  }

  Future<void> _onLoadMore(
      LoadMorePetsEvent event, Emitter<AdoptionBrowseState> emit) async {
    if (!state.hasMore ||
        state.status == AdoptionBrowseStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: AdoptionBrowseStatus.loadingMore));
    final nextPage = state.currentPage + 1;
    final result = await _getPagedPets(_buildParams(state, pageIndex: nextPage));
    result.fold(
      (f) => emit(state.copyWith(
          status: AdoptionBrowseStatus.loaded, errorMessage: f.message)),
      (r) => emit(state.copyWith(
        status: AdoptionBrowseStatus.loaded,
        pets: [...state.pets, ...r.items],
        totalCount: r.totalCount,
        currentPage: nextPage,
        hasMore: r.items.length >= _pageSize,
      )),
    );
  }

  Future<void> _onSearch(
      SearchPetsEvent event, Emitter<AdoptionBrowseState> emit) async {
    final updated = state.copyWith(
      searchQuery: event.query.isEmpty ? null : event.query,
      clearSearch: event.query.isEmpty,
    );
    emit(updated.copyWith(status: AdoptionBrowseStatus.loading));
    final result = await _getPagedPets(_buildParams(updated));
    result.fold(
      (f) => emit(updated.copyWith(
          status: AdoptionBrowseStatus.error, errorMessage: f.message)),
      (r) => emit(updated.copyWith(
        status: AdoptionBrowseStatus.loaded,
        pets: r.items,
        totalCount: r.totalCount,
        currentPage: 0,
        hasMore: r.items.length >= _pageSize,
      )),
    );
  }

  Future<void> _onFilterCategory(
      FilterByCategoryEvent event, Emitter<AdoptionBrowseState> emit) async {
    final updated = state.copyWith(
      selectedCategoryId: event.categoryId,
      clearCategory: event.categoryId == null,
    );
    emit(updated.copyWith(status: AdoptionBrowseStatus.loading));
    final result = await _getPagedPets(_buildParams(updated));
    result.fold(
      (f) => emit(updated.copyWith(
          status: AdoptionBrowseStatus.error, errorMessage: f.message)),
      (r) => emit(updated.copyWith(
        status: AdoptionBrowseStatus.loaded,
        pets: r.items,
        totalCount: r.totalCount,
        currentPage: 0,
        hasMore: r.items.length >= _pageSize,
      )),
    );
  }

  Future<void> _onFilterGender(
      FilterByGenderEvent event, Emitter<AdoptionBrowseState> emit) async {
    final updated = state.copyWith(
      selectedGenderId: event.genderId,
      clearGender: event.genderId == null,
    );
    emit(updated.copyWith(status: AdoptionBrowseStatus.loading));
    final result = await _getPagedPets(_buildParams(updated));
    result.fold(
      (f) => emit(updated.copyWith(
          status: AdoptionBrowseStatus.error, errorMessage: f.message)),
      (r) => emit(updated.copyWith(
        status: AdoptionBrowseStatus.loaded,
        pets: r.items,
        totalCount: r.totalCount,
        currentPage: 0,
        hasMore: r.items.length >= _pageSize,
      )),
    );
  }

  Future<void> _onSort(
      SortPetsEvent event, Emitter<AdoptionBrowseState> emit) async {
    final updated = state.copyWith(
      sortBy: event.sortBy,
      sortDescending: event.descending,
      clearSort: event.sortBy == null,
    );
    emit(updated.copyWith(status: AdoptionBrowseStatus.loading));
    final result = await _getPagedPets(_buildParams(updated));
    result.fold(
      (f) => emit(updated.copyWith(
          status: AdoptionBrowseStatus.error, errorMessage: f.message)),
      (r) => emit(updated.copyWith(
        status: AdoptionBrowseStatus.loaded,
        pets: r.items,
        totalCount: r.totalCount,
        currentPage: 0,
        hasMore: r.items.length >= _pageSize,
      )),
    );
  }

  Future<void> _onReset(
      ResetFiltersEvent event, Emitter<AdoptionBrowseState> emit) async {
    final reset = AdoptionBrowseState(categories: state.categories);
    emit(reset.copyWith(status: AdoptionBrowseStatus.loading));
    final result = await _getPagedPets(_buildParams(reset));
    result.fold(
      (f) => emit(reset.copyWith(
          status: AdoptionBrowseStatus.error, errorMessage: f.message)),
      (r) => emit(reset.copyWith(
        status: AdoptionBrowseStatus.loaded,
        pets: r.items,
        totalCount: r.totalCount,
        currentPage: 0,
        hasMore: r.items.length >= _pageSize,
      )),
    );
  }
}
