import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_bloc.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_event.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_state.dart';
import 'package:pettix/features/my_pets/presentation/widgets/pet_id_card.dart';

/// Horizontal scroll section shown inside the profile screen.
class PetsSection extends StatelessWidget {
  final bool isCurrentUser;
  final int? userId;

  const PetsSection({super.key, this.isCurrentUser = true, this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyPetsBloc, MyPetsState>(
      listenWhen:
          (prev, curr) =>
              prev.status != curr.status &&
              curr.status == MyPetsStatus.success,
      listener: (context, _) {
        context.read<MyPetsBloc>().add(FetchUserPetsEvent(userId: userId));
      },
      builder: (context, state) {
        if (state.status == MyPetsStatus.loading && state.pets.isEmpty) {
          return const _LoadingRow();
        }

        if (state.pets.isEmpty) {
          return const _EmptyPetsCard();
        }

        return SizedBox(
          height: 128.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: state.pets.length,
            itemBuilder: (context, index) {
              return PetIdCard(pet: state.pets[index]);
            },
          ),
        );
      },
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyPetsCard extends StatelessWidget {
  const _EmptyPetsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.current.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.current.primary.withValues(alpha: 0.12),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.current.primary.withValues(alpha: 0.15),
                  AppColors.current.teal.withValues(alpha: 0.15),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: AppIcon.raw(
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
}

// ── Loading skeleton ──────────────────────────────────────────────────────────

class _LoadingRow extends StatelessWidget {
  const _LoadingRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (_, __) => const _SkeletonCard(),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 252.w,
      height: 128.h,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(
            width: 6.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.current.lightGray,
                  AppColors.current.lightGray.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            child: Row(
              children: [
                AppShimmer(
                  width: 74.w,
                  height: 96.h,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppShimmer(
                      width: 60.w,
                      height: 8.h,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    SizedBox(height: 6.h),
                    AppShimmer(
                      width: 100.w,
                      height: 14.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    SizedBox(height: 6.h),
                    AppShimmer(
                      width: 90.w,
                      height: 10.h,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    SizedBox(height: 8.h),
                    AppShimmer(
                      width: 70.w,
                      height: 10.h,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        AppShimmer(
                          width: 40.w,
                          height: 18.h,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        SizedBox(width: 5.w),
                        AppShimmer(
                          width: 32.w,
                          height: 18.h,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
