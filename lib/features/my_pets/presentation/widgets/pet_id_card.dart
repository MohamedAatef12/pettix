import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_cached_image.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';
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
    return Container(
      width: 252.w,
      height: 128.h,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.current.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => showPetPassport(
            context,
            pet,
            onToggleStatus: onToggleStatus,
            onEditPet: onEditPet,
            onDeletePet: onDeletePet,
          ),
          child: Stack(
            children: [
              _GradientAccentBar(),
              PositionedDirectional(
                end: -16.w,
                bottom: -16.w,
                child: AppIcon.raw(
                  Icons.pets_rounded,
                  size: 80.w,
                  color: AppColors.current.primary.withValues(alpha: 0.05),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  16.w,
                  10.h,
                  10.w,
                  10.h,
                ),
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
      ),
    );
  }
}

class _GradientAccentBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      start: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 6.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.current.primary, AppColors.current.teal],
          ),
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
      width: 74.w,
      height: 96.h,
      decoration: BoxDecoration(
        color: AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.current.lightGray.withValues(alpha: 0.8),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9.r),
        child: AppCachedImage(
          imageUrl: imageUrl ?? '',
          fit: BoxFit.cover,
          errorWidget: _PetPhotoPlaceholder(),
          backgroundColor: AppColors.current.lightBlue,
        ),
      ),
    );
  }
}

class _PetPhotoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppIcon.raw(
        Icons.pets_rounded,
        color: AppColors.current.primary.withValues(alpha: 0.35),
        size: 28.w,
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
    ].join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppText.pettixPetId,
          style: TextStyle(
            color: AppColors.current.primary,
            fontSize: 8.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 3.h),
        Text(
          pet.name.toUpperCase(),
          style: TextStyle(
            color: AppColors.current.text,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        _CodeStrip(code: pet.code),
        SizedBox(height: 5.h),
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
            if (pet.age != null && hasVaccination) SizedBox(width: 5.w),
            if (hasVaccination)
              _MiniBadge(
                icon: Icons.verified_rounded,
                label: '${pet.vaccinations.length}',
                color: AppColors.current.teal,
              ),
          ],
        ),
      ],
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
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(
        code,
        style: TextStyle(
          color: AppColors.current.text,
          fontSize: 8.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
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
      height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIcon.raw(icon, color: badgeColor, size: 11.w),
          SizedBox(width: 3.w),
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
