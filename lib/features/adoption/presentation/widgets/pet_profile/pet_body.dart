import 'package:flutter/material.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/adoption/presentation/widgets/pet_profile/pet_description.dart';
import 'package:pettix/features/adoption/presentation/widgets/pet_profile/pet_details.dart';
import 'package:pettix/features/adoption/presentation/widgets/pet_profile/pet_medical_history.dart';
import 'package:pettix/features/adoption/presentation/widgets/pet_profile/pet_photos.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PetBody extends StatelessWidget {
  final PetEntity pet;

  const PetBody({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              PetGallery(pet: pet),
              PetDetails(pet: pet),
              PetDescription(pet: pet),
              PetMedicalHistory(pet: pet),
              SizedBoxConstants.verticalExtraLarge,
            ],
          ),
        ),
        _AdoptBottomBar(pet: pet),
      ],
    );
  }
}

class _AdoptBottomBar extends StatelessWidget {
  final PetEntity pet;

  const _AdoptBottomBar({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => context.push(AppRoutes.applications),
        icon: const Icon(Icons.pets_rounded, size: 20),
        label: const Text('Apply to Adopt'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.current.primary,
          foregroundColor: AppColors.current.white,
          minimumSize: Size(double.infinity, 50.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
