import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

class PetDescription extends StatelessWidget {
  final PetEntity pet;

  const PetDescription({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final hasContent =
        (pet.description != null && pet.description!.isNotEmpty) ||
        (pet.details != null && pet.details!.isNotEmpty);

    if (!hasContent) return const SizedBox.shrink();

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
            'About ${pet.name}',
            style: AppTextStyles.bodyTitle.copyWith(
              fontSize: 16.sp,
              color: AppColors.current.text,
            ),
          ),
          if (pet.description != null && pet.description!.isNotEmpty) ...[
            SizedBoxConstants.verticalSmall,
            Text(
              pet.description!,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.current.lightText,
                height: 1.6,
              ),
            ),
          ],
          if (pet.details != null && pet.details!.isNotEmpty) ...[
            SizedBoxConstants.verticalSmall,
            Text(
              pet.details!,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.current.lightText,
                height: 1.6,
              ),
            ),
          ],
          SizedBoxConstants.verticalMedium,
          OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.chat_bubble_outline_rounded,
                size: 16.w, color: AppColors.current.primary),
            label: Text(
              'Message Owner',
              style: TextStyle(
                  fontSize: 14.sp, color: AppColors.current.primary),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 44.h),
              side: BorderSide(color: AppColors.current.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
