import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_bloc.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_event.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_state.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/filter_sheet.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/pet_browse_card.dart';

class AdoptionBody extends StatelessWidget {
  const AdoptionBody({super.key});

  void _onScrollNotification(
    BuildContext context,
    ScrollNotification notification,
  ) {
    if (notification is! ScrollUpdateNotification) return;
    final metrics = notification.metrics;
    if (metrics.pixels < metrics.maxScrollExtent - 300) return;
    final bloc = context.read<AdoptionBrowseBloc>();
    if (bloc.state.hasMore && bloc.state.status == AdoptionBrowseStatus.loaded) {
      bloc.add(const LoadMorePetsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AdoptionBrowseBloc>();
    return Column(
      children: [
        _AdoptionHeader(searchController: bloc.searchController),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.current.primary,
            onRefresh: () async {
              bloc.add(const RefreshPetsEvent());
              await bloc.stream.firstWhere(
                (s) =>
                    s.status == AdoptionBrowseStatus.loaded ||
                    s.status == AdoptionBrowseStatus.error,
              );
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (n) {
                _onScrollNotification(context, n);
                return false;
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: const [
                  _CategoryFilterSliver(),
                  _ResultsCountSliver(),
                  _PetGridSliver(),
                  _LoadMoreSliver(),
                  SliverToBoxAdapter(child: SizedBox(height: 80)),
                ],
              ),
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

  const _AdoptionHeader({required this.searchController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pets_rounded, color: AppColors.current.gold, size: 20.w),
                SizedBoxConstants.horizontalSmall,
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
                color: AppColors.current.text,
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(child: _SearchField(controller: searchController)),
                SizedBox(width: 10.w),
                const _FilterButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;

  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.current.lightGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: (q) =>
            context.read<AdoptionBrowseBloc>().add(SearchPetsEvent(q)),
        style: TextStyle(color: AppColors.current.text, fontSize: 13.sp),
        decoration: InputDecoration(
          hintText: 'Search by name...',
          hintStyle: TextStyle(color: AppColors.current.midGray, fontSize: 13.sp),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.current.midGray,
            size: 18.w,
          ),
          suffixIcon: BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
            buildWhen: (p, c) =>
                (p.searchQuery?.isNotEmpty ?? false) !=
                (c.searchQuery?.isNotEmpty ?? false),
            builder: (context, state) {
              final hasQuery =
                  state.searchQuery != null && state.searchQuery!.isNotEmpty;
              if (!hasQuery) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: AppColors.current.midGray,
                  size: 16.w,
                ),
                onPressed: () {
                  controller.clear();
                  context
                      .read<AdoptionBrowseBloc>()
                      .add(const SearchPetsEvent(''));
                },
              );
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
      buildWhen: (p, c) => p.hasActiveFilters != c.hasActiveFilters,
      builder: (context, state) {
        return GestureDetector(
          onTap: () => showFilterSheet(context),
          child: Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: state.hasActiveFilters
                  ? AppColors.current.gold
                  : AppColors.current.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: state.hasActiveFilters
                    ? AppColors.current.gold
                    : AppColors.current.lightGray,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: state.hasActiveFilters
                  ? AppColors.current.white
                  : AppColors.current.midGray,
              size: 20.w,
            ),
          ),
        );
      },
    );
  }
}

// ─── Category chips ───────────────────────────────────────────────────────────

class _CategoryFilterSliver extends StatelessWidget {
  const _CategoryFilterSliver();

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
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              children: [
                _CategoryChip(
                  label: 'All',
                  selected: state.selectedCategoryId == null,
                  onTap: () => context
                      .read<AdoptionBrowseBloc>()
                      .add(const FilterByCategoryEvent(null)),
                ),
                ...state.categories.map(
                  (cat) => _CategoryChip(
                    label: cat.name,
                    selected: state.selectedCategoryId == cat.id,
                    onTap: () => context
                        .read<AdoptionBrowseBloc>()
                        .add(FilterByCategoryEvent(cat.id)),
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
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.current.white : AppColors.current.text,
              fontSize: 12.sp,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Results count ────────────────────────────────────────────────────────────

class _ResultsCountSliver extends StatelessWidget {
  const _ResultsCountSliver();

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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
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
  const _PetGridSliver();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
      buildWhen: (p, c) => p.pets != c.pets || p.status != c.status,
      builder: (context, state) {
        if (state.status == AdoptionBrowseStatus.loading) {
          return const _SkeletonGrid();
        }
        if (state.status == AdoptionBrowseStatus.error && state.pets.isEmpty) {
          return _ErrorSliver(
            message: state.errorMessage,
            onRetry: () => context
                .read<AdoptionBrowseBloc>()
                .add(const RefreshPetsEvent()),
          );
        }
        if (state.pets.isEmpty && state.status == AdoptionBrowseStatus.loaded) {
          return const _EmptySliver();
        }
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

// ─── Load more ────────────────────────────────────────────────────────────────

class _LoadMoreSliver extends StatelessWidget {
  const _LoadMoreSliver();

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
  const _SkeletonGrid();

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
              color: AppColors.current.lightGray,
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
  const _EmptySliver();

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded,
                size: 64.w, color: AppColors.current.blueGray),
            SizedBoxConstants.verticalMedium,
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
            SizedBoxConstants.verticalSmall,
            Text(
              message ?? 'Something went wrong',
              style: TextStyle(
                  color: AppColors.current.midGray, fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
            SizedBoxConstants.verticalMedium,
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: TextStyle(
                  color: AppColors.current.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
