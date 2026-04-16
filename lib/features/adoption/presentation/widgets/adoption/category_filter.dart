import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_bloc.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_event.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_state.dart';

class CategoryFilterSliver extends StatelessWidget {
  const CategoryFilterSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
      buildWhen:
          (p, c) =>
              p.categories != c.categories ||
              p.selectedCategoryId != c.selectedCategoryId,
      builder: (context, state) {
        if (state.categories.isEmpty) return const SliverToBoxAdapter();
        return SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: SizedBox(
              height: 50.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 4.h),
                children: [
                  CategoryChip(
                    label: 'All Pets',
                    icon: Icons.grid_view_rounded,
                    selected: state.selectedCategoryId == null,
                    onTap:
                        () => context.read<AdoptionBrowseBloc>().add(
                          const FilterByCategoryEvent(null),
                        ),
                  ),
                  ...state.categories.map(
                    (cat) => CategoryChip(
                      label: cat.name,
                      icon: _iconForCategory(cat.name),
                      selected: state.selectedCategoryId == cat.id,
                      onTap:
                          () => context.read<AdoptionBrowseBloc>().add(
                            FilterByCategoryEvent(cat.id),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static IconData _iconForCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('dog')) return Icons.pets_rounded;
    if (lower.contains('cat')) return Icons.auto_awesome_rounded;
    if (lower.contains('bird')) return Icons.flutter_dash_rounded;
    return Icons.pets_rounded;
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.current.primary : AppColors.current.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: AppColors.current.primary.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color:
                  selected
                      ? AppColors.current.white
                      : AppColors.current.primary,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: AppTextStyles.description.copyWith(
                color:
                    selected ? AppColors.current.white : AppColors.current.text,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
