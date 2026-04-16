import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import '../../bloc/adoption_bloc.dart';
import '../../bloc/adoption_event.dart';
import '../../bloc/adoption_state.dart';

class Step2LivingSituation extends StatelessWidget {
  const Step2LivingSituation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBloc, AdoptionState>(
      builder: (context, state) {
        final options = state.options;
        return ListView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
          children: [
            _SectionLabel(label: 'Living Situation'),
            SizedBox(height: 12.h),
            if (options == null || options.livingSituations.isEmpty)
              _EmptyHint()
            else
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 2.8,
                children:
                    options.livingSituations.map((e) {
                      return _SelectCard(
                        label: e.name,
                        icon: _livingSituationIcon(e.name),
                        selected: state.selectedLivingSituationId == e.id,
                        onTap:
                            () => context.read<AdoptionBloc>().add(
                              UpdateLivingSituation(e.id),
                            ),
                      );
                    }).toList(),
              ),
            SizedBoxConstants.verticalMedium,
            _SectionLabel(label: 'Type of Residence'),
            SizedBox(height: 12.h),
            if (options == null || options.residenceTypes.isEmpty)
              _EmptyHint()
            else
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 2.8,
                children:
                    options.residenceTypes.map((e) {
                      return _SelectCard(
                        label: e.name,
                        icon: _residenceIcon(e.name),
                        selected: state.selectedResidenceTypeId == e.id,
                        onTap:
                            () => context.read<AdoptionBloc>().add(
                              UpdateResidenceType(e.id),
                            ),
                      );
                    }).toList(),
              ),
          ],
        );
      },
    );
  }

  IconData _livingSituationIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('alone')) return Icons.person_outline_rounded;
    if (lower.contains('family')) return Icons.family_restroom_rounded;
    if (lower.contains('partner')) return Icons.favorite_border_rounded;
    if (lower.contains('roommate')) return Icons.people_outline_rounded;
    return Icons.home_outlined;
  }

  IconData _residenceIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('apartment')) return Icons.apartment_rounded;
    if (lower.contains('house')) return Icons.house_outlined;
    if (lower.contains('villa')) return Icons.villa_outlined;
    if (lower.contains('studio')) return Icons.bed_outlined;
    return Icons.location_city_outlined;
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.description.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        'Loading options...',
        style: AppTextStyles.smallDescription.copyWith(
          color: AppColors.current.midGray,
        ),
      ),
    );
  }
}

// Shared widget — also used in Step 3
class _SelectCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SelectCard({
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
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color:
              selected
                  ? AppColors.current.primary.withValues(alpha: 0.08)
                  : AppColors.current.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color:
                selected
                    ? AppColors.current.primary
                    : AppColors.current.lightGray,
            width: selected ? 1.8 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18.w,
              color:
                  selected
                      ? AppColors.current.primary
                      : AppColors.current.midGray,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.smallDescription.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color:
                      selected
                          ? AppColors.current.primary
                          : AppColors.current.text,
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                size: 16.w,
                color: AppColors.current.primary,
              ),
          ],
        ),
      ),
    );
  }
}

// Keep exported so step3 can use it
class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onSelected;

  const CustomChoiceChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        decoration: BoxDecoration(
          color:
              selected
                  ? AppColors.current.primary.withValues(alpha: 0.08)
                  : AppColors.current.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color:
                selected
                    ? AppColors.current.primary
                    : AppColors.current.lightGray,
            width: selected ? 1.8 : 1.2,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.description.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color:
                selected ? AppColors.current.primary : AppColors.current.text,
          ),
        ),
      ),
    );
  }
}
