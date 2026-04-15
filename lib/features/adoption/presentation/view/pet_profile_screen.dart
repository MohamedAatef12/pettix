import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/features/adoption/presentation/widgets/pet_profile/pet_body.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

class PetProfileScreen extends StatelessWidget {
  final PetEntity pet;

  const PetProfileScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.current.white,
        surfaceTintColor: AppColors.current.white,
        title: Text(pet.name, style: AppTextStyles.appbar),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.current.text),
          onPressed: () => context.pop(),
        ),
      ),
      body: PetBody(pet: pet),
    );
  }
}
