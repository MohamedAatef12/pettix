import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_bloc.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_event.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_state.dart';

void showFilterSheet(BuildContext context) {
  context.read<AdoptionBrowseBloc>().add(const OpenFilterSheet());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (_) => BlocProvider.value(
          value: context.read<AdoptionBrowseBloc>(),
          child: const FilterSheet(),
        ),
  );
}

class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdoptionBrowseBloc, AdoptionBrowseState>(
      listener: (context, state) {
        if (state.draftGenderId == null &&
            state.draftSortBy == null &&
            !state.draftSortDescending) {
          // Draft was reset — close the sheet
          Navigator.of(context).pop();
        }
      },
      listenWhen: (p, c) {
        // Only listen when draft values have been explicitly reset
        return p.draftGenderId != null && c.draftGenderId == null;
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.current.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.current.lightGray,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBoxConstants.verticalMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter & Sort',
                    style: AppTextStyles.bodyTitle.copyWith(
                      fontSize: 20.sp,
                      color: AppColors.current.text,
                    ),
                  ),
                  GestureDetector(
                    onTap:
                        () => context.read<AdoptionBrowseBloc>().add(
                          const ResetDraftFilters(),
                        ),
                    child: Text(
                      'Reset All',
                      style: TextStyle(
                        color: AppColors.current.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 28.h),
              _SectionLabel('GENDER'),
              SizedBox(height: 12.h),
              const _GenderChips(),
              SizedBox(height: 28.h),
              _SectionLabel('SORT BY'),
              SizedBox(height: 12.h),
              const _SortChips(),
              SizedBox(height: 20.h),
              const _OrderToggle(),
              SizedBox(height: 32.h),
              CustomFilledButton(
                onPressed: () {
                  context.read<AdoptionBrowseBloc>().add(
                    const ApplyDraftFilters(),
                  );
                  Navigator.of(context).pop();
                },
                text: 'Apply Filters',
                widthFactor: 1.0,
                heightFactor: 0.065,
                backgroundColor: AppColors.current.primary,
                textStyle: AppTextStyles.button.copyWith(
                  color: AppColors.current.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.smallDescription.copyWith(
        color: AppColors.current.midGray,
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _GenderChips extends StatelessWidget {
  const _GenderChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
      buildWhen: (p, c) => p.draftGenderId != c.draftGenderId,
      builder: (context, state) {
        final selected = state.draftGenderId;
        final options = [
          (id: null, label: 'All', icon: Icons.pets_rounded),
          (id: 1, label: 'Male', icon: Icons.male_rounded),
          (id: 2, label: 'Female', icon: Icons.female_rounded),
        ];

        return Wrap(
          spacing: 8.w,
          children:
              options.map((o) {
                final active = selected == o.id;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        o.icon,
                        size: 14.w,
                        color:
                            active ? Colors.white : AppColors.current.midGray,
                      ),
                      SizedBox(width: 4.w),
                      Text(o.label),
                    ],
                  ),
                  selected: active,
                  onSelected:
                      (_) => context.read<AdoptionBrowseBloc>().add(
                        SetDraftFilters(genderId: o.id),
                      ),
                  selectedColor: AppColors.current.primary,
                  backgroundColor: AppColors.current.lightBlue,
                  labelStyle: TextStyle(
                    color: active ? Colors.white : AppColors.current.text,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  side: BorderSide.none,
                );
              }).toList(),
        );
      },
    );
  }
}

class _SortChips extends StatelessWidget {
  const _SortChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
      buildWhen: (p, c) => p.draftSortBy != c.draftSortBy,
      builder: (context, state) {
        final selected = state.draftSortBy;
        const options = [
          (value: null, label: 'Default'),
          (value: 'name', label: 'Name'),
          (value: 'age', label: 'Age'),
        ];

        return Wrap(
          spacing: 8.w,
          children:
              options.map((o) {
                final active = selected == o.value;
                return ChoiceChip(
                  label: Text(o.label),
                  selected: active,
                  onSelected:
                      (_) => context.read<AdoptionBrowseBloc>().add(
                        SetDraftFilters(sortBy: o.value),
                      ),
                  selectedColor: AppColors.current.primary,
                  backgroundColor: AppColors.current.lightBlue,
                  labelStyle: TextStyle(
                    color: active ? Colors.white : AppColors.current.text,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  side: BorderSide.none,
                );
              }).toList(),
        );
      },
    );
  }
}

class _OrderToggle extends StatelessWidget {
  const _OrderToggle();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBrowseBloc, AdoptionBrowseState>(
      buildWhen: (p, c) => p.draftSortDescending != c.draftSortDescending,
      builder: (context, state) {
        final descending = state.draftSortDescending;
        return Row(
          children: [
            Text(
              'Order:',
              style: TextStyle(
                color: AppColors.current.midGray,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 12.w),
            _OrderChip(
              label: 'Ascending',
              icon: Icons.arrow_upward_rounded,
              active: !descending,
              onTap:
                  () => context.read<AdoptionBrowseBloc>().add(
                    const SetDraftFilters(descending: false),
                  ),
            ),
            SizedBox(width: 8.w),
            _OrderChip(
              label: 'Descending',
              icon: Icons.arrow_downward_rounded,
              active: descending,
              onTap:
                  () => context.read<AdoptionBrowseBloc>().add(
                    const SetDraftFilters(descending: true),
                  ),
            ),
          ],
        );
      },
    );
  }
}

class _OrderChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _OrderChip({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        active ? AppColors.current.primary : AppColors.current.midGray;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color:
              active
                  ? AppColors.current.primary.withAlpha(20)
                  : AppColors.current.lightBlue,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color:
                active
                    ? AppColors.current.primary.withAlpha(80)
                    : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12.w, color: color),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
