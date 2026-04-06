import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_bloc.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_event.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_state.dart';
import 'package:pettix/features/my_pets/presentation/widgets/pet_id_card.dart';

/// Horizontal scroll section shown inside the profile screen.
/// Displays an "Add Pet" card at the start followed by pet ID cards.
class PetsSection extends StatelessWidget {
  const PetsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyPetsBloc, MyPetsState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status &&
          curr.status == MyPetsStatus.success,
      listener: (context, _) {
        context.read<MyPetsBloc>().add(const FetchUserPetsEvent());
      },
      builder: (context, state) {
        if (state.status == MyPetsStatus.loading &&
            state.pets.isEmpty) {
          return _LoadingRow();
        }

        return SizedBox(
          height: 125.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            children: [
              _AddPetCard(
                onTap: () => context.push(
                  AppRoutes.addPet,
                  extra: context.read<MyPetsBloc>(),
                ),
              ),
              ...state.pets.map((pet) => PetIdCard(pet: pet)),
            ],
          ),
        );
      },
    );
  }
}

class _LoadingRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (_, __) => _SkeletonCard(),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.w,
      height: 125.h,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }
}

/// Dashed-border card used to trigger add-pet navigation.
class _AddPetCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPetCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90.w,
        height: 125.h,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.current.primary.withAlpha(100),
            width: 1.5,
            style: BorderStyle.solid,
          ),
          color: AppColors.current.lightBlue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.current.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_rounded,
                color: AppColors.current.primary,
                size: 20.w,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Add Pet',
              style: TextStyle(
                color: AppColors.current.primary,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
