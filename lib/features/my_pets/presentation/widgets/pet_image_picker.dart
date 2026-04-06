import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_bloc.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_event.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_state.dart';

/// Horizontal row showing picked pet images with a remove button and a + card.
class PetImagePickerRow extends StatelessWidget {
  const PetImagePickerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyPetsBloc, MyPetsState>(
      buildWhen: (prev, curr) =>
          prev.pickedImageBytes != curr.pickedImageBytes,
      builder: (context, state) {
        final images = state.pickedImageBytes;
        return SizedBox(
          height: 90.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...images.asMap().entries.map(
                    (entry) => _ImageThumb(
                      bytes: entry.value,
                      onRemove: () => context
                          .read<MyPetsBloc>()
                          .add(RemovePetImageEvent(entry.key)),
                    ),
                  ),
              if (images.length < 3) _AddImageCard(),
            ],
          ),
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
          width: 80.w,
          height: 80.w,
          margin: EdgeInsets.only(right: 8.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            image: DecorationImage(
              image: MemoryImage(bytes),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 2.h,
          right: 10.w,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(140),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close_rounded, color: Colors.white, size: 12.w),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddImageCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.read<MyPetsBloc>().add(const PickPetImageEvent()),
      child: Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          color: AppColors.current.lightBlue,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.current.primary.withAlpha(80),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined,
                color: AppColors.current.primary, size: 22.w),
            SizedBox(height: 4.h),
            Text(
              'Photo',
              style: TextStyle(
                color: AppColors.current.primary,
                fontSize: 9.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
