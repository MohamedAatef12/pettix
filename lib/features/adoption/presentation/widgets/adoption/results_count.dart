import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_bloc.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_event.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_state.dart';

class ResultsCountSliver extends StatelessWidget {
  const ResultsCountSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
      buildWhen: (p, c) => p.totalCount != c.totalCount || p.status != c.status,
      builder: (context, state) {
        final isLoaded =
            state.status == AdoptionBrowseStatus.loaded ||
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
                  style: AppTextStyles.smallDescription.copyWith(
                    color: AppColors.current.midGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (state.hasActiveFilters)
                  GestureDetector(
                    onTap:
                        () => context.read<AdoptionBrowseBloc>().add(
                          const ResetFiltersEvent(),
                        ),
                    child: Text(
                      'Clear filters',
                      style: AppTextStyles.smallDescription.copyWith(
                        color: AppColors.current.primary,
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
