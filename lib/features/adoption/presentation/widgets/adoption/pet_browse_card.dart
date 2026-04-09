import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/data/network/constants.dart';
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

    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Photo ──────────────────────────────────────────────
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.r),
                  ),
                  child:
                      fullUrl != null
                          ? Image.network(
                            fullUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _PhotoPlaceholder(),
                          )
                          : _PhotoPlaceholder(),
                ),
                // Gender badge
                if (pet.genderName != null)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: _GenderBadge(gender: pet.genderName!),
                  ),
              ],
            ),
          ),
          // ── Info ───────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name,
                  style: TextStyle(
                    color: AppColors.current.text,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    if (pet.categoryName != null) ...[
                      Icon(
                        Icons.pets_rounded,
                        color: AppColors.current.primary,
                        size: 11.w,
                      ),
                      SizedBox(width: 3.w),
                      Flexible(
                        child: Text(
                          pet.categoryName!,
                          style: TextStyle(
                            color: AppColors.current.midGray,
                            fontSize: 11.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    if (pet.age != null) ...[
                      SizedBox(width: 6.w),
                      Text(
                        '· ${pet.age}y',
                        style: TextStyle(
                          color: AppColors.current.midGray,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 8.h),
                // View Profile button
                SizedBox(
                  width: double.infinity,
                  height: 32.h,
                  child: ElevatedButton(
                    onPressed: onViewProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.current.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'View Profile',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
