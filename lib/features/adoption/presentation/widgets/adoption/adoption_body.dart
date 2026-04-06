import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_bloc.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_event.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_state.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/filter_sheet.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/pet_browse_card.dart';

class AdoptionBody extends StatefulWidget {
  const AdoptionBody({super.key});

  @override
  State<AdoptionBody> createState() => _AdoptionBodyState();
}

class _AdoptionBodyState extends State<AdoptionBody> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      final bloc = context.read<AdoptionBrowseBloc>();
      if (bloc.state.hasMore &&
          bloc.state.status == AdoptionBrowseStatus.loaded) {
        bloc.add(const LoadMorePetsEvent());
      }
    }
  }

  void _onSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<AdoptionBrowseBloc>().add(SearchPetsEvent(query));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AdoptionHeader(
          searchController: _searchController,
          onSearch: _onSearch,
        ),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.current.primary,
            onRefresh: () async {
              context
                  .read<AdoptionBrowseBloc>()
                  .add(const RefreshPetsEvent());
              await context
                  .read<AdoptionBrowseBloc>()
                  .stream
                  .firstWhere((s) =>
                      s.status == AdoptionBrowseStatus.loaded ||
                      s.status == AdoptionBrowseStatus.error);
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _CategoryFilterSliver(),
                _ResultsCountSliver(),
                _PetGridSliver(),
                _LoadMoreSliver(),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _AdoptionHeader extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const _AdoptionHeader({
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.current.primary, const Color(0xFF2A4E8F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.pets_rounded,
                      color: AppColors.current.gold, size: 20.w),
                  SizedBox(width: 8.w),
                  Text(
                    'PETTIX ADOPTION',
                    style: TextStyle(
                      color: AppColors.current.gold,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                'Find Your Fur-ever\nFriend',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 16.h),
              // Search + Filter row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(20),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                            color: Colors.white.withAlpha(40), width: 1),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: onSearch,
                        style: TextStyle(
                            color: Colors.white, fontSize: 13.sp),
                        decoration: InputDecoration(
                          hintText: 'Search by name...',
                          hintStyle: TextStyle(
                              color: Colors.white60, fontSize: 13.sp),
                          prefixIcon: Icon(Icons.search_rounded,
                              color: Colors.white60, size: 18.w),
                          suffixIcon: BlocBuilder<AdoptionBrowseBloc,
                              AdoptionBrowseState>(
                            buildWhen: (p, c) =>
                                (p.searchQuery != null) !=
                                (c.searchQuery != null),
                            builder: (context, state) {
                              if (state.searchQuery == null ||
                                  state.searchQuery!.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return IconButton(
                                icon: Icon(Icons.close_rounded,
                                    color: Colors.white60, size: 16.w),
                                onPressed: () {
                                  searchController.clear();
                                  context
                                      .read<AdoptionBrowseBloc>()
                                      .add(const SearchPetsEvent(''));
                                },
                              );
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  // Filter button
                  BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
                    buildWhen: (p, c) =>
                        p.hasActiveFilters != c.hasActiveFilters,
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () => showFilterSheet(context),
                        child: Container(
                          width: 44.w,
                          height: 44.h,
                          decoration: BoxDecoration(
                            color: state.hasActiveFilters
                                ? AppColors.current.gold
                                : Colors.white.withAlpha(20),
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                                color: state.hasActiveFilters
                                    ? AppColors.current.gold
                                    : Colors.white.withAlpha(40),
                                width: 1),
                          ),
                          child: Icon(Icons.tune_rounded,
                              color: Colors.white, size: 20.w),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Category chips ───────────────────────────────────────────────────────────

class _CategoryFilterSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
      buildWhen: (p, c) =>
          p.categories != c.categories ||
          p.selectedCategoryId != c.selectedCategoryId,
      builder: (context, state) {
        if (state.categories.isEmpty) return const SliverToBoxAdapter();
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 44.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              children: [
                _CategoryChip(
                  label: 'All',
                  selected: state.selectedCategoryId == null,
                  onTap: () => context
                      .read<AdoptionBrowseBloc>()
                      .add(const FilterByCategoryEvent(null)),
                ),
                ...state.categories.map((cat) => _CategoryChip(
                      label: cat.name,
                      selected: state.selectedCategoryId == cat.id,
                      onTap: () => context
                          .read<AdoptionBrowseBloc>()
                          .add(FilterByCategoryEvent(cat.id)),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.current.primary
              : AppColors.current.lightBlue,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected
                ? AppColors.current.primary
                : AppColors.current.lightGray,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.current.text,
              fontSize: 12.sp,
              fontWeight:
                  selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Results count ────────────────────────────────────────────────────────────

class _ResultsCountSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
      buildWhen: (p, c) =>
          p.totalCount != c.totalCount || p.status != c.status,
      builder: (context, state) {
        final isLoaded = state.status == AdoptionBrowseStatus.loaded ||
            state.status == AdoptionBrowseStatus.loadingMore;
        if (!isLoaded) return const SliverToBoxAdapter();
        return SliverToBoxAdapter(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${state.totalCount} pets available',
                  style: TextStyle(
                    color: AppColors.current.midGray,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (state.hasActiveFilters)
                  GestureDetector(
                    onTap: () => context
                        .read<AdoptionBrowseBloc>()
                        .add(const ResetFiltersEvent()),
                    child: Text(
                      'Clear filters',
                      style: TextStyle(
                        color: AppColors.current.primary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Pet grid ─────────────────────────────────────────────────────────────────

class _PetGridSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
      buildWhen: (p, c) => p.pets != c.pets || p.status != c.status,
      builder: (context, state) {
        if (state.status == AdoptionBrowseStatus.loading) {
          return _SkeletonGrid();
        }

        if (state.status == AdoptionBrowseStatus.error &&
            state.pets.isEmpty) {
          return _ErrorSliver(
            message: state.errorMessage,
            onRetry: () => context
                .read<AdoptionBrowseBloc>()
                .add(const RefreshPetsEvent()),
          );
        }

        if (state.pets.isEmpty &&
            state.status == AdoptionBrowseStatus.loaded) {
          return _EmptySliver();
        }

        return SliverPadding(
          padding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.72,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final pet = state.pets[i];
                return PetBrowseCard(
                  pet: pet,
                  onViewProfile: () =>
                      context.push(AppRoutes.petProfile, extra: pet),
                );
              },
              childCount: state.pets.length,
            ),
          ),
        );
      },
    );
  }
}

// ─── Load more indicator ──────────────────────────────────────────────────────

class _LoadMoreSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
      buildWhen: (p, c) => p.status != c.status,
      builder: (context, state) {
        if (state.status != AdoptionBrowseStatus.loadingMore) {
          return const SliverToBoxAdapter();
        }
        return SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(
              child: SizedBox(
                width: 24.w,
                height: 24.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.current.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Skeleton ─────────────────────────────────────────────────────────────────

class _SkeletonGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.72,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, __) => Container(
            decoration: BoxDecoration(
              color: AppColors.current.lightBlue,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          childCount: 6,
        ),
      ),
    );
  }
}

// ─── Empty / Error states ─────────────────────────────────────────────────────

class _EmptySliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 64.w, color: AppColors.current.blueGray),
            SizedBox(height: 16.h),
            Text(
              'No pets found',
              style: TextStyle(
                color: AppColors.current.midGray,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorSliver extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const _ErrorSliver({this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 48.w, color: AppColors.current.red),
            SizedBox(height: 12.h),
            Text(
              message ?? 'Something went wrong',
              style: TextStyle(
                  color: AppColors.current.midGray, fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: TextStyle(
                    color: AppColors.current.primary,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

