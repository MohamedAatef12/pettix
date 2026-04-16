import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

class PetMedicalHistory extends StatelessWidget {
  final PetEntity pet;

  const PetMedicalHistory({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    if (pet.vaccinations.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.current.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medical History',
            style: AppTextStyles.bodyTitle.copyWith(
              fontSize: 16.sp,
              color: AppColors.current.text,
            ),
          ),
          SizedBoxConstants.verticalSmall,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children:
                pet.vaccinations
                    .map((v) => _VaccinationChip(name: v.name))
                    .toList(),
          ),
        ],
      ),
    );
  }
}

class _VaccinationChip extends StatelessWidget {
  final String name;

  const _VaccinationChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.current.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.current.green.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 14.w,
            color: AppColors.current.green,
          ),
          SizedBox(width: 4.w),
          Text(
            name,
            style: AppTextStyles.smallDescription.copyWith(
              color: AppColors.current.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
