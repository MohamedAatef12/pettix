import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_bloc.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_event.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_state.dart';

/// Horizontal row showing picked pet images with a remove button and a + card.
class PetImagePickerRow extends StatelessWidget {
  const PetImagePickerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyPetsBloc, MyPetsState>(
      buildWhen: (prev, curr) => prev.pickedImageBytes != curr.pickedImageBytes,
      builder: (context, state) {
        final images = state.pickedImageBytes;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 3.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.current.primary,
                        AppColors.current.teal,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  AppText.photo,
                  style: TextStyle(
                    color: AppColors.current.text,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  '${images.length}/3',
                  style: TextStyle(
                    color: AppColors.current.midGray,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 100.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...images.asMap().entries.map(
                    (entry) => _ImageThumb(
                      bytes: entry.value,
                      onRemove:
                          () => context.read<MyPetsBloc>().add(
                            RemovePetImageEvent(entry.key),
                          ),
                    ),
                  ),
                  if (images.length < 3) const _AddImageCard(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ImageThumb extends StatelessWidget {
  final Uint8List bytes;
  final VoidCallback onRemove;

  const _ImageThumb({required this.bytes, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 96.w,
          height: 96.w,
          margin: EdgeInsets.only(right: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            image: DecorationImage(
              image: MemoryImage(bytes),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        Positioned(
          top: 4.h,
          right: 14.w,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                shape: BoxShape.circle,
              ),
              child: AppIcon.raw(
                Icons.close_rounded,
                color: Colors.white,
                size: 13.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddImageCard extends StatelessWidget {
  const _AddImageCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
            () => context.read<MyPetsBloc>().add(const PickPetImageEvent()),
        borderRadius: BorderRadius.circular(14.r),
        child: Ink(
          width: 96.w,
          height: 96.w,
          decoration: BoxDecoration(
            color: AppColors.current.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: AppColors.current.primary.withValues(alpha: 0.30),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.current.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: AppIcon.raw(
                  Icons.add_a_photo_outlined,
                  color: AppColors.current.primary,
                  size: 18.w,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                AppText.photo,
                style: TextStyle(
                  color: AppColors.current.primary,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
