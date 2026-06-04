import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_bloc.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_event.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_state.dart';

import 'package:pettix/features/my_pets/presentation/widgets/pet_id_card.dart';

/// Horizontal scroll section shown inside the profile screen.
/// Displays an "Add Pet" card at the start followed by pet ID cards.
class PetsSection extends StatelessWidget {
  final bool isCurrentUser;
  final int? userId;
  const PetsSection({super.key, this.isCurrentUser = true, this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyPetsBloc, MyPetsState>(
      listenWhen:
          (prev, curr) =>
              prev.status != curr.status && curr.status == MyPetsStatus.success,
      listener: (context, _) {
        context.read<MyPetsBloc>().add(FetchUserPetsEvent(userId: userId));
      },
      builder: (context, state) {
        if (state.status == MyPetsStatus.loading && state.pets.isEmpty) {
          return _LoadingRow();
        }

        if (state.pets.isEmpty) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.current.lightBlue.withAlpha(80),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.current.primary.withAlpha(40),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.current.primary.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.pets_rounded,
                    color: AppColors.current.primary,
                    size: 22.w,
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppText.noPetsRegisteredYet,
                        style: TextStyle(
                          color: AppColors.current.text,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        AppText.petsSectionEmptyDescription,
                        style: TextStyle(
                          color: AppColors.current.midGray,
                          fontSize: 10.sp,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return SizedBox(
          height: 125.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: state.pets.length,
            itemBuilder: (context, index) {
              final pet = state.pets[index];
              return PetIdCard(pet: pet);
            },
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
