import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_cached_image.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:pettix/features/my_pets/presentation/widgets/pet_passport.dart';

/// Document-style card displayed in the horizontal pet list on the profile.
class PetIdCard extends StatelessWidget {
  final PetEntity pet;
  final ValueChanged<int>? onToggleStatus;
  final VoidCallback? onEditPet;
  final VoidCallback? onDeletePet;

  const PetIdCard({
    super.key,
    required this.pet,
    this.onToggleStatus,
    this.onEditPet,
    this.onDeletePet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => showPetPassport(
            context,
            pet,
            onToggleStatus: onToggleStatus,
            onEditPet: onEditPet,
            onDeletePet: onDeletePet,
          ),
      child: Container(
        width: 248.w,
        height: 125.h,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.current.lightGray),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 8.w, color: AppColors.current.primary),
            ),
            PositionedDirectional(
              end: -18.w,
              bottom: -18.w,
              child: Icon(
                Icons.pets_rounded,
                size: 84.w,
                color: AppColors.current.primary.withAlpha(10),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(18.w, 10.h, 10.w, 10.h),
              child: Row(
                children: [
                  _PetPhoto(imageUrl: pet.imageUrls.firstOrNull),
                  SizedBox(width: 10.w),
                  Expanded(child: _PetCardInfo(pet: pet)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetPhoto extends StatelessWidget {
  final String? imageUrl;

  const _PetPhoto({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.w,
      height: 94.h,
      decoration: BoxDecoration(
        color: AppColors.current.lightGray.withAlpha(70),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.current.lightGray),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9.r),
        child: AppCachedImage(
          imageUrl: imageUrl ?? '',
          fit: BoxFit.cover,
          errorWidget: _PawPlaceholder(),
          backgroundColor: AppColors.current.lightGray.withAlpha(70),
        ),
      ),
    );
  }
}

class _PawPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.pets_rounded,
        color: AppColors.current.primary.withAlpha(90),
        size: 30.w,
      ),
    );
  }
}

class _PetCardInfo extends StatelessWidget {
  final PetEntity pet;

  const _PetCardInfo({required this.pet});

  @override
  Widget build(BuildContext context) {
    final hasVaccination = pet.vaccinations.isNotEmpty;
    final details = [
      if (pet.categoryName?.isNotEmpty ?? false) pet.categoryName!,
      if (pet.genderName?.isNotEmpty ?? false) pet.genderName!,
    ].join(' / ');

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: FittedBox(
            alignment: AlignmentDirectional.topStart,
            fit: BoxFit.scaleDown,
            child: SizedBox(
              width: constraints.maxWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppText.pettixPetId,
                          style: TextStyle(
                            color: AppColors.current.primary,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.qr_code_2_rounded,
                        color: AppColors.current.text,
                        size: 18.w,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    pet.name.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.current.text,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  _CodeStrip(code: pet.code),
                  SizedBox(height: 4.h),
                  if (details.isNotEmpty)
                    Text(
                      details,
                      style: TextStyle(
                        color: AppColors.current.midGray,
                        fontSize: 9.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      if (pet.age != null)
                        _MiniBadge(
                          icon: Icons.cake_rounded,
                          label: '${pet.age} ${AppText.yearsShort}',
                        ),
                      if (pet.age != null && hasVaccination)
                        SizedBox(width: 6.w),
                      if (hasVaccination)
                        _MiniBadge(
                          icon: Icons.verified_rounded,
                          label: '${pet.vaccinations.length}',
                          color: AppColors.current.teal,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CodeStrip extends StatelessWidget {
  final String code;

  const _CodeStrip({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.current.lightGray.withAlpha(70),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.current.lightGray),
      ),
      child: Text(
        code,
        style: TextStyle(
          color: AppColors.current.text,
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _MiniBadge({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? AppColors.current.primary;
    return Container(
      height: 22.h,
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(18),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: badgeColor, size: 12.w),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: badgeColor,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
