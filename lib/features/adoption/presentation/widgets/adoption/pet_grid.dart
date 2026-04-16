import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_bloc.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_event.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_state.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/pet_browse_card.dart';

class PetGridSliver extends StatelessWidget {
  const PetGridSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
      buildWhen: (p, c) => p.pets != c.pets || p.status != c.status,
      builder: (context, state) {
        if (state.status == AdoptionBrowseStatus.loading) {
          return const SkeletonGrid();
        }
        if (state.status == AdoptionBrowseStatus.error && state.pets.isEmpty) {
          return ErrorState(
            message: state.errorMessage,
            onRetry:
                () => context.read<AdoptionBrowseBloc>().add(
                  const RefreshPetsEvent(),
                ),
          );
        }
        if (state.pets.isEmpty && state.status == AdoptionBrowseStatus.loaded) {
          return const EmptyState();
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
            delegate: SliverChildBuilderDelegate((context, i) {
              final pet = state.pets[i];
              return PetBrowseCard(
                pet: pet,
                onViewProfile:
                    () => context.push(AppRoutes.petProfile, extra: pet),
              );
            }, childCount: state.pets.length),
          ),
        );
      },
    );
  }
}

class LoadMoreSliver extends StatelessWidget {
  const LoadMoreSliver({super.key});

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

class SkeletonGrid extends StatelessWidget {
  const SkeletonGrid({super.key});

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

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64.w,
              color: AppColors.current.blueGray,
            ),
            SizedBoxConstants.verticalMedium,
            Text(
              'No pets found',
              style: AppTextStyles.description.copyWith(
                color: AppColors.current.midGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback onRetry;

  const ErrorState({super.key, this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48.w,
              color: AppColors.current.red,
            ),
            SizedBoxConstants.verticalSmall,
            Text(
              message ?? 'Something went wrong',
              style: AppTextStyles.smallDescription.copyWith(
                color: AppColors.current.midGray,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBoxConstants.verticalMedium,
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: AppTextStyles.description.copyWith(
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
