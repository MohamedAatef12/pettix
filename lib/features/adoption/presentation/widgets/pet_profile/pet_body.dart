import 'package:flutter/material.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/adoption/presentation/widgets/pet_profile/pet_description.dart';
import 'package:pettix/features/adoption/presentation/widgets/pet_profile/pet_details.dart';
import 'package:pettix/features/adoption/presentation/widgets/pet_profile/pet_medical_history.dart';
import 'package:pettix/features/adoption/presentation/widgets/pet_profile/pet_photos.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/utils/custom_button.dart';

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
      child: CustomFilledButton(
        text: 'Apply to Adopt',
        onPressed: () => context.push(AppRoutes.applications, extra: pet.id),
        hasLeading: true,
        leading: const Icon(Icons.pets_rounded, size: 20, color: Colors.white),
        widthFactor: 1.0,
        heightFactor: 0.065,
        backgroundColor: AppColors.current.primary,
        textStyle: AppTextStyles.button.copyWith(
          color: AppColors.current.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
