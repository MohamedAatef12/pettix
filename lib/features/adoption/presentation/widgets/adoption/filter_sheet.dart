import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_bloc.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_event.dart';

void showFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<AdoptionBrowseBloc>(),
      child: const _FilterSheet(),
    ),
  );
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet();

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  int? _genderId;
  String? _sortBy;
  bool _descending = false;

  @override
  void initState() {
    super.initState();
    final s = context.read<AdoptionBrowseBloc>().state;
    _genderId = s.selectedGenderId;
    _sortBy = s.sortBy;
    _descending = s.sortDescending;
  }

  @override
  Widget build(BuildContext context) {
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
          // Handle
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
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter & Sort',
                style: TextStyle(
                  color: AppColors.current.text,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _genderId = null;
                    _sortBy = null;
                    _descending = false;
                  });
                },
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
          _GenderChips(
            selected: _genderId,
            onSelected: (id) => setState(() => _genderId = id),
          ),
          SizedBox(height: 28.h),
          _SectionLabel('SORT BY'),
          SizedBox(height: 12.h),
          _SortChips(
            selected: _sortBy,
            onSelected: (s) => setState(() => _sortBy = s),
          ),
          SizedBox(height: 20.h),
          _OrderToggle(
            descending: _descending,
            onToggle: (v) => setState(() => _descending = v),
          ),
          SizedBox(height: 32.h),
          SizedBox(
            width: double.infinity,
            height: 54.h,
            child: ElevatedButton(
              onPressed: _apply,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.current.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 0,
                shadowColor: AppColors.current.primary.withValues(alpha: 0.3),
              ),
              child: Text(
                'Apply Filters',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _apply() {
    final bloc = context.read<AdoptionBrowseBloc>();
    final current = bloc.state;
    if (current.selectedGenderId != _genderId) {
      bloc.add(FilterByGenderEvent(_genderId));
    }
    if (current.sortBy != _sortBy || current.sortDescending != _descending) {
      bloc.add(SortPetsEvent(sortBy: _sortBy, descending: _descending));
    }
    Navigator.of(context).pop();
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: AppColors.current.midGray,
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }
}

class _GenderChips extends StatelessWidget {
  final int? selected;
  final ValueChanged<int?> onSelected;

  const _GenderChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final options = [
      (id: null, label: 'All', icon: Icons.pets_rounded),
      (id: 1, label: 'Male', icon: Icons.male_rounded),
      (id: 2, label: 'Female', icon: Icons.female_rounded),
    ];

    return Wrap(
      spacing: 8.w,
      children: options.map((o) {
        final active = selected == o.id;
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(o.icon,
                  size: 14.w,
                  color: active
                      ? Colors.white
                      : AppColors.current.midGray),
              SizedBox(width: 4.w),
              Text(o.label),
            ],
          ),
          selected: active,
          onSelected: (_) => onSelected(o.id),
          selectedColor: AppColors.current.primary,
          backgroundColor: AppColors.current.lightBlue,
          labelStyle: TextStyle(
            color: active ? Colors.white : AppColors.current.text,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r)),
          side: BorderSide.none,
        );
      }).toList(),
    );
  }
}

class _SortChips extends StatelessWidget {
  final String? selected;
  final ValueChanged<String?> onSelected;

  const _SortChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    const options = [
      (value: null, label: 'Default'),
      (value: 'name', label: 'Name'),
      (value: 'age', label: 'Age'),
    ];

    return Wrap(
      spacing: 8.w,
      children: options.map((o) {
        final active = selected == o.value;
        return ChoiceChip(
          label: Text(o.label),
          selected: active,
          onSelected: (_) => onSelected(o.value),
          selectedColor: AppColors.current.primary,
          backgroundColor: AppColors.current.lightBlue,
          labelStyle: TextStyle(
            color: active ? Colors.white : AppColors.current.text,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r)),
          side: BorderSide.none,
        );
      }).toList(),
    );
  }
}

class _OrderToggle extends StatelessWidget {
  final bool descending;
  final ValueChanged<bool> onToggle;

  const _OrderToggle({required this.descending, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Order:',
          style: TextStyle(
              color: AppColors.current.midGray,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 12.w),
        _OrderChip(
          label: 'Ascending',
          icon: Icons.arrow_upward_rounded,
          active: !descending,
          onTap: () => onToggle(false),
        ),
        SizedBox(width: 8.w),
        _OrderChip(
          label: 'Descending',
          icon: Icons.arrow_downward_rounded,
          active: descending,
          onTap: () => onToggle(true),
        ),
      ],
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
          color: active
              ? AppColors.current.primary.withAlpha(20)
              : AppColors.current.lightBlue,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
              color: active
                  ? AppColors.current.primary.withAlpha(80)
                  : Colors.transparent),
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
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
