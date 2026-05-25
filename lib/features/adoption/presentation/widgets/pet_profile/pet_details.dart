import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

class PetDetails extends StatelessWidget {
  final PetEntity pet;

  const PetDetails({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Expanded(
                child: Text(
                  pet.name,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 20.sp,
                    color: AppColors.current.text,
                  ),
                ),
              ),
            ],
          ),
          SizedBoxConstants.verticalSmall,
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: [
              if (pet.categoryName != null) _Chip(label: pet.categoryName!),
              if (pet.genderName != null) _Chip(label: pet.genderName!),
              if (pet.age != null) _Chip(label: '${pet.age} yr'),
              if (pet.colorName != null) _Chip(label: pet.colorName!),
              _Chip(label: '#${pet.code}', isCode: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isCode;

  const _Chip({required this.label, this.isCode = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color:
            isCode
                ? AppColors.current.primary.withValues(alpha: 0.1)
                : AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isCode ? AppColors.current.primary : AppColors.current.text,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
