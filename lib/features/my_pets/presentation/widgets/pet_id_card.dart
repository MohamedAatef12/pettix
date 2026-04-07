import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';
import 'package:pettix/features/my_pets/presentation/widgets/pet_passport.dart';

/// National-ID-style card displayed in the horizontal pet list on the profile.
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
      onTap: () => showPetPassport(
        context,
        pet,
        onToggleStatus: onToggleStatus,
        onEditPet: onEditPet,
        onDeletePet: onDeletePet,
      ),
      child: Container(
        width: 220.w,
        height: 125.h,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            colors: [
              AppColors.current.primary,
              const Color(0xFF2A4E8F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.current.primary.withAlpha(80),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            _CardBackground(),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  _PetAvatar(imageUrl: pet.imageUrls.firstOrNull),
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

/// Decorative diagonal stripe pattern overlay for the card background.
class _CardBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: CustomPaint(painter: _StripePainter()),
      ),
    );
  }
}

/// Circular avatar showing the pet's first image or a paw placeholder.
class _PetAvatar extends StatelessWidget {
  final String? imageUrl;

  const _PetAvatar({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha(30),
        border: Border.all(color: Colors.white.withAlpha(100), width: 2),
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _PawPlaceholder(),
              )
            : _PawPlaceholder(),
      ),
    );
  }
}

class _PawPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.pets_rounded, color: Colors.white.withAlpha(160), size: 28.w),
    );
  }
}

/// Right section of the card: header label, pet name, code, attributes.
class _PetCardInfo extends StatelessWidget {
  final PetEntity pet;

  const _PetCardInfo({required this.pet});

  @override
  Widget build(BuildContext context) {
    final hasVaccination = pet.vaccinations.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Header
        Row(
          children: [
            Icon(Icons.pets_rounded, color: AppColors.current.gold, size: 10.w),
            SizedBox(width: 4.w),
            Text(
              'PETTIX PET ID',
              style: TextStyle(
                color: AppColors.current.gold,
                fontSize: 8.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        // Pet name
        Text(
          pet.name.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        // Code
        Text(
          pet.code,
          style: TextStyle(
            color: Colors.white.withAlpha(200),
            fontSize: 8.sp,
            letterSpacing: 1.2,
            fontFamily: 'monospace',
          ),
        ),
        // Attributes row
        Row(
          children: [
            Expanded(
              child: Text(
                '${pet.categoryName ?? ''} · ${pet.genderName ?? ''}',
                style: TextStyle(
                  color: Colors.white.withAlpha(180),
                  fontSize: 9.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        // Age + vaccination badge
        Row(
          children: [
            if (pet.age != null)
              Text(
                'Age: ${pet.age}',
                style: TextStyle(
                  color: Colors.white.withAlpha(160),
                  fontSize: 9.sp,
                ),
              ),
            const Spacer(),
            if (hasVaccination)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.current.teal.withAlpha(180),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.vaccines_rounded, color: Colors.white, size: 8.w),
                    SizedBox(width: 2.w),
                    Text(
                      '${pet.vaccinations.length}',
                      style: TextStyle(color: Colors.white, fontSize: 8.sp),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Subtle diagonal stripe decoration painted on the card background.
class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(10)
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke;

    for (double i = -size.height; i < size.width + size.height; i += 30) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StripePainter oldDelegate) => false;
}
