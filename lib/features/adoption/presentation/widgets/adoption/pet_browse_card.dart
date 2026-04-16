import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

class PetBrowseCard extends StatelessWidget {
  final PetEntity pet;
  final VoidCallback onViewProfile;

  const PetBrowseCard({
    super.key,
    required this.pet,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = pet.imageUrls.firstOrNull;
    final fullUrl = imageUrl != null && imageUrl.isNotEmpty ? imageUrl : null;

    return GestureDetector(
      onTap: onViewProfile,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Photo ──────────────────────────────────────────────
            Expanded(
              flex: 5,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                      child:
                          fullUrl != null
                              ? Image.network(
                                fullUrl,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => const _PhotoPlaceholder(),
                              )
                              : const _PhotoPlaceholder(),
                    ),
                  ),
                  // Gender badge
                  if (pet.genderName != null)
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: _GenderBadge(gender: pet.genderName!),
                    ),
                ],
              ),
            ),
            // ── Info ───────────────────────────────────────────────
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pet.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.description.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: Hero(
                            tag: 'cat_${pet.id}',
                            child: Text(
                              pet.categoryName ?? 'Unknown',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.smallDescription.copyWith(
                                color: AppColors.current.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '•',
                          style: TextStyle(
                            color: AppColors.current.blueGray,
                            fontSize: 12.sp,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          pet.age != null ? '${pet.age} yrs' : 'Age unknown',
                          maxLines: 1,
                          style: AppTextStyles.smallDescription.copyWith(
                            color: AppColors.current.blueGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.current.lightBlue,
      child: Center(
        child: Icon(
          Icons.pets_rounded,
          color: AppColors.current.primary.withAlpha(80),
          size: 48.w,
        ),
      ),
    );
  }
}

class _GenderBadge extends StatelessWidget {
  final String gender;

  const _GenderBadge({required this.gender});

  @override
  Widget build(BuildContext context) {
    final isMale = gender.toLowerCase().startsWith('m');
    final color = isMale ? const Color(0xFF5EA8DF) : const Color(0xFFE8A838);
    final icon = isMale ? Icons.male_rounded : Icons.female_rounded;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: color.withAlpha(80), blurRadius: 6)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 10.w),
          SizedBox(width: 2.w),
          Text(
            gender,
            style: AppTextStyles.smallDescription.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
