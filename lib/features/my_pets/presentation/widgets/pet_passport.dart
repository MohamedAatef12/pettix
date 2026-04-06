import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/enums/app_enums.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

/// Opens the pet passport overlay.
/// [onToggleStatus] is called when the owner taps the availability toggle.
/// Pass null to hide the toggle (e.g., when viewing someone else's pet).
void showPetPassport(
  BuildContext context,
  PetEntity pet, {
  VoidCallback? onToggleStatus,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Pet Passport',
    barrierColor: Colors.black.withAlpha(160),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => _PetPassportDialog(
      pet: pet,
      onToggleStatus: onToggleStatus,
    ),
    transitionBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );
      return ScaleTransition(scale: curved, child: child);
    },
  );
}

// ─── Dialog ───────────────────────────────────────────────────────────────────

class _PetPassportDialog extends StatefulWidget {
  final PetEntity pet;
  final VoidCallback? onToggleStatus;

  const _PetPassportDialog({required this.pet, this.onToggleStatus});

  @override
  State<_PetPassportDialog> createState() => _PetPassportDialogState();
}

class _PetPassportDialogState extends State<_PetPassportDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _showingFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _animation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_controller.isAnimating) return;
    if (_showingFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() => _showingFront = !_showingFront);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 300.w,
          height: 480.h,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (_, __) {
                  final angle = _animation.value;
                  final isFrontVisible = angle < pi / 2;
                  return Transform(
                    transform: Matrix4.rotationY(angle),
                    alignment: Alignment.center,
                    child: isFrontVisible
                        ? _PassportFront(
                            pet: widget.pet,
                            onFlip: _flip,
                          )
                        : Transform(
                            transform: Matrix4.rotationY(pi),
                            alignment: Alignment.center,
                            child: _PassportBack(
                              pet: widget.pet,
                              onFlip: _flip,
                              onToggleStatus: widget.onToggleStatus,
                            ),
                          ),
                  );
                },
              ),
              // Close button
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(100),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 16.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Front face ───────────────────────────────────────────────────────────────

class _PassportFront extends StatelessWidget {
  final PetEntity pet;
  final VoidCallback onFlip;

  const _PassportFront({required this.pet, required this.onFlip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFlip,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            colors: [
              AppColors.current.primary,
              const Color(0xFF1E3A6E),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.current.primary.withAlpha(100),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            _PassportFrontHeader(),
            Expanded(child: _PassportFrontBody(pet: pet)),
            _PassportFrontFooter(pet: pet, onFlip: onFlip),
          ],
        ),
      ),
    );
  }
}

class _PassportFrontHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.pets_rounded, color: AppColors.current.gold, size: 16.w),
              SizedBox(width: 6.w),
              Text(
                'PETTIX',
                style: TextStyle(
                  color: AppColors.current.gold,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          Text(
            'PET PASSPORT',
            style: TextStyle(
              color: Colors.white.withAlpha(180),
              fontSize: 9.sp,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PassportFrontBody extends StatelessWidget {
  final PetEntity pet;

  const _PassportFrontBody({required this.pet});

  @override
  Widget build(BuildContext context) {
    final imageUrl = pet.imageUrls.firstOrNull;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.current.gold, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(60),
                blurRadius: 20,
              ),
            ],
          ),
          child: ClipOval(
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _PhotoPlaceholder(size: 120.w),
                  )
                : _PhotoPlaceholder(size: 120.w),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          pet.name.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 4.h),
        if (pet.categoryName != null)
          Text(
            pet.categoryName!,
            style: TextStyle(
              color: Colors.white.withAlpha(180),
              fontSize: 13.sp,
            ),
          ),
      ],
    );
  }
}

class _PassportFrontFooter extends StatelessWidget {
  final PetEntity pet;
  final VoidCallback onFlip;

  const _PassportFrontFooter({required this.pet, required this.onFlip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          Text(
            pet.code,
            style: TextStyle(
              color: Colors.white.withAlpha(200),
              fontSize: 11.sp,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app_rounded,
                  color: Colors.white.withAlpha(120), size: 14.w),
              SizedBox(width: 6.w),
              Text(
                'Tap to see full details',
                style: TextStyle(
                  color: Colors.white.withAlpha(120),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Back face ────────────────────────────────────────────────────────────────

class _PassportBack extends StatelessWidget {
  final PetEntity pet;
  final VoidCallback onFlip;
  final VoidCallback? onToggleStatus;

  const _PassportBack({
    required this.pet,
    required this.onFlip,
    this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFlip,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.current.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            _BackHeader(pet: pet),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  children: [
                    _InfoRow(label: 'Code', value: pet.code),
                    if (pet.age != null)
                      _InfoRow(label: 'Age', value: '${pet.age} years'),
                    if (pet.categoryName != null)
                      _InfoRow(label: 'Category', value: pet.categoryName!),
                    if (pet.genderName != null)
                      _InfoRow(label: 'Gender', value: pet.genderName!),
                    if (pet.colorName != null)
                      _InfoRow(label: 'Color', value: pet.colorName!),
                    if (pet.description != null && pet.description!.isNotEmpty)
                      _InfoBlock(label: 'About', value: pet.description!),
                    if (pet.details != null && pet.details!.isNotEmpty)
                      _InfoBlock(label: 'Health & Details', value: pet.details!),
                    if (pet.vaccinations.isNotEmpty) ...[
                      _BackSectionTitle('Medical Records'),
                      ...pet.vaccinations.map(
                        (v) => _VaccinationTile(vaccination: v),
                      ),
                    ],
                    if (onToggleStatus != null) ...[
                      SizedBox(height: 12.h),
                      _StatusToggleButton(
                        adoptionStatus: pet.adoptionStatus,
                        onToggle: onToggleStatus!,
                      ),
                    ],
                    SizedBox(height: 8.h),
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

class _BackHeader extends StatelessWidget {
  final PetEntity pet;

  const _BackHeader({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: AppColors.current.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(100), width: 2),
            ),
            child: ClipOval(
              child: pet.imageUrls.firstOrNull != null
                  ? Image.network(
                      pet.imageUrls.first,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _PhotoPlaceholder(size: 36.w),
                    )
                  : _PhotoPlaceholder(size: 36.w),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  pet.categoryName ?? '',
                  style: TextStyle(
                    color: Colors.white.withAlpha(180),
                    fontSize: 10.sp,
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

class _BackSectionTitle extends StatelessWidget {
  final String title;

  const _BackSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(width: 3.w, height: 14.h, color: AppColors.current.primary),
          SizedBox(width: 6.w),
          Text(
            title.toUpperCase(),
            style: AppTextStyles.smallDescription.copyWith(
              color: AppColors.current.primary,
              fontSize: 9.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.current.midGray,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.current.text,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBlock({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.current.midGray,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              color: AppColors.current.text,
              fontSize: 11.sp,
              height: 1.4,
            ),
          ),
          Divider(height: 12.h, color: AppColors.current.lightGray),
        ],
      ),
    );
  }
}

class _VaccinationTile extends StatelessWidget {
  final VaccinationEntity vaccination;

  const _VaccinationTile({required this.vaccination});

  @override
  Widget build(BuildContext context) {
    final date = vaccination.vaccinationDate;
    final dateLabel = date != null
        ? '${date.day}/${date.month}/${date.year}'
        : 'Date unknown';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: AppColors.current.teal.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.vaccines_rounded,
              color: AppColors.current.teal,
              size: 12.w,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vaccination.name,
                  style: TextStyle(
                    color: AppColors.current.text,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  dateLabel,
                  style: TextStyle(
                    color: AppColors.current.midGray,
                    fontSize: 9.sp,
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

// ─── Status toggle button ─────────────────────────────────────────────────────

class _StatusToggleButton extends StatelessWidget {
  final int? adoptionStatus;
  final VoidCallback onToggle;

  const _StatusToggleButton({required this.adoptionStatus, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isAvailable = PetAdoptionStatus.fromValue(adoptionStatus) ==
        PetAdoptionStatus.available;

    final color = isAvailable ? AppColors.current.midGray : AppColors.current.green;
    final icon = isAvailable ? Icons.visibility_off_rounded : Icons.pets_rounded;
    final label = isAvailable ? 'Make Private' : 'Make Available for Adoption';

    return GestureDetector(
      onTap: onToggle,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withAlpha(80), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16.w),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Generic paw-print placeholder for missing pet images.
class _PhotoPlaceholder extends StatelessWidget {
  final double size;

  const _PhotoPlaceholder({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: Colors.white.withAlpha(20),
      child: Icon(Icons.pets_rounded, color: Colors.white.withAlpha(120), size: size * 0.4),
    );
  }
}
