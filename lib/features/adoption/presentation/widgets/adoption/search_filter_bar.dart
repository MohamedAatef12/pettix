import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_bloc.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_event.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_state.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/filter_sheet.dart';

class AdoptionHeader extends StatelessWidget {
  final TextEditingController searchController;

  const AdoptionHeader({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 10.h, 20.w, 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Find Your Pet Partner',
                style: AppTextStyles.title.copyWith(
                  fontSize: 24.sp,
                  color: AppColors.current.primary,
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(child: SearchField(controller: searchController)),
                  SizedBox(width: 12.w),
                  const FilterButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final TextEditingController controller;

  const SearchField({super.key, required this.controller});

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
        onChanged:
            (q) => context.read<AdoptionBrowseBloc>().add(SearchPetsEvent(q)),
        style: AppTextStyles.smallDescription.copyWith(
          color: AppColors.current.text,
        ),
        decoration: InputDecoration(
          hintText: 'Search by name...',
          hintStyle: AppTextStyles.smallDescription.copyWith(
            color: AppColors.current.midGray,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.current.midGray,
            size: 18.w,
          ),
          suffixIcon: BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
            buildWhen:
                (p, c) =>
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
                  context.read<AdoptionBrowseBloc>().add(
                    const SearchPetsEvent(''),
                  );
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

class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

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
              color:
                  state.hasActiveFilters
                      ? AppColors.current.gold
                      : AppColors.current.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color:
                    state.hasActiveFilters
                        ? AppColors.current.gold
                        : AppColors.current.lightGray,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.tune_rounded,
              color:
                  state.hasActiveFilters
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
