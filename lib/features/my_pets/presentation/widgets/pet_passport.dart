import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_cached_image.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

import 'package:pettix/core/widgets/app_icon_system.dart';

/// Opens the pet passport overlay.
/// Pass null callbacks to show a read-only passport.
void showPetPassport(
  BuildContext context,
  PetEntity pet, {
  ValueChanged<int>? onToggleStatus,
  VoidCallback? onEditPet,
  VoidCallback? onDeletePet,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: AppText.petPassport,
    barrierColor: Colors.black.withAlpha(160),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder:
        (_, __, ___) => _PetPassportDialog(
          pet: pet,
          onToggleStatus: onToggleStatus,
          onEditPet: onEditPet,
          onDeletePet: onDeletePet,
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

class _PetPassportDialog extends StatefulWidget {
  final PetEntity pet;
  final ValueChanged<int>? onToggleStatus;
  final VoidCallback? onEditPet;
  final VoidCallback? onDeletePet;

  const _PetPassportDialog({
    required this.pet,
    this.onToggleStatus,
    this.onEditPet,
    this.onDeletePet,
  });

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
    _animation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_controller.isAnimating) return;
    _showingFront ? _controller.forward() : _controller.reverse();
    setState(() => _showingFront = !_showingFront);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 318.w,
          height: 500.h,
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
                    child:
                        isFrontVisible
                            ? _PassportFront(pet: widget.pet, onFlip: _flip)
                            : Transform(
                              transform: Matrix4.rotationY(pi),
                              alignment: Alignment.center,
                              child: _PassportBack(
                                pet: widget.pet,
                                onFlip: _flip,
                                onToggleStatus: widget.onToggleStatus,
                                onEditPet: widget.onEditPet,
                                onDeletePet: widget.onDeletePet,
                              ),
                            ),
                  );
                },
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(110),
                      shape: BoxShape.circle,
                    ),
                    child: AppIcon.raw(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 17.w,
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

class PetPassportCard extends StatefulWidget {
  final PetEntity pet;
  final bool initiallyShowingFront;
  final ValueChanged<int>? onToggleStatus;
  final VoidCallback? onEditPet;
  final VoidCallback? onDeletePet;

  const PetPassportCard({
    super.key,
    required this.pet,
    this.initiallyShowingFront = true,
    this.onToggleStatus,
    this.onEditPet,
    this.onDeletePet,
  });

  @override
  State<PetPassportCard> createState() => _PetPassportCardState();
}

class _PetPassportCardState extends State<PetPassportCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late bool _showingFront;

  @override
  void initState() {
    super.initState();
    _showingFront = widget.initiallyShowingFront;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: widget.initiallyShowingFront ? 0 : 1,
    );
    _animation = Tween<double>(
      begin: 0,
      end: pi,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant PetPassportCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pet.id != widget.pet.id) {
      _showingFront = widget.initiallyShowingFront;
      _controller.value = widget.initiallyShowingFront ? 0 : 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_controller.isAnimating) return;
    _showingFront ? _controller.forward() : _controller.reverse();
    setState(() => _showingFront = !_showingFront);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final angle = _animation.value;
        final isFrontVisible = angle < pi / 2;
        return Transform(
          transform: Matrix4.rotationY(angle),
          alignment: Alignment.center,
          child:
              isFrontVisible
                  ? _PassportFront(pet: widget.pet, onFlip: _flip)
                  : Transform(
                    transform: Matrix4.rotationY(pi),
                    alignment: Alignment.center,
                    child: _PassportBack(
                      pet: widget.pet,
                      onFlip: _flip,
                      onToggleStatus: widget.onToggleStatus,
                      onEditPet: widget.onEditPet,
                      onDeletePet: widget.onDeletePet,
                    ),
                  ),
        );
      },
    );
  }
}

class _PassportFront extends StatelessWidget {
  final PetEntity pet;
  final VoidCallback onFlip;

  const _PassportFront({required this.pet, required this.onFlip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFlip,
      child: Container(
        decoration: _pageDecoration(),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _PassportHeader(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 12.h),
                child: Column(
                  children: [
                    _IdentityPanel(pet: pet),
                    SizedBox(height: 14.h),
                    _FrontFieldGrid(pet: pet),
                    const Spacer(),
                    _PassportFooter(code: pet.code),
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

class _PassportHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82.h,
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 48.w, 12.h),
      color: AppColors.current.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon.raw(
                Icons.pets_rounded,
                color: AppColors.current.gold,
                size: 18.w,
              ),
              SizedBox(width: 7.w),
              Text(
                AppText.pettixBrand,
                style: TextStyle(
                  color: AppColors.current.gold,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            AppText.petPassportUpper,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityPanel extends StatelessWidget {
  final PetEntity pet;

  const _IdentityPanel({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.current.lightGray.withAlpha(70),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.current.lightGray),
      ),
      child: Row(
        children: [
          _PassportPhoto(imageUrl: pet.imageUrls.firstOrNull, size: 96.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppText.pettixPetId,
                  style: TextStyle(
                    color: AppColors.current.primary,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  pet.name.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.current.text,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                _CodePlate(code: pet.code),
                SizedBox(height: 10.h),
                _VerifiedStamp(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FrontFieldGrid extends StatelessWidget {
  final PetEntity pet;

  const _FrontFieldGrid({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DocumentField(
            label: AppText.category,
            value: pet.categoryName ?? '-',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _DocumentField(
            label: AppText.gender,
            value: pet.genderName ?? '-',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _DocumentField(
            label: AppText.age,
            value: pet.age != null ? '${pet.age} ${AppText.yearsShort}' : '-',
          ),
        ),
      ],
    );
  }
}

class _PassportFooter extends StatelessWidget {
  final String code;

  const _PassportFooter({required this.code});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52.w,
          height: 52.w,
          decoration: BoxDecoration(
            color: AppColors.current.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.current.lightGray),
          ),
          child: AppIcon.raw(
            Icons.qr_code_2_rounded,
            color: AppColors.current.text,
            size: 40.w,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                code,
                style: TextStyle(
                  color: AppColors.current.text,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  AppIcon.raw(
                    Icons.touch_app_rounded,
                    color: AppColors.current.midGray,
                    size: 14.w,
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      AppText.tapFullDetails,
                      style: TextStyle(
                        color: AppColors.current.midGray,
                        fontSize: 10.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PassportBack extends StatelessWidget {
  final PetEntity pet;
  final VoidCallback onFlip;
  final ValueChanged<int>? onToggleStatus;
  final VoidCallback? onEditPet;
  final VoidCallback? onDeletePet;

  const _PassportBack({
    required this.pet,
    required this.onFlip,
    this.onToggleStatus,
    this.onEditPet,
    this.onDeletePet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFlip,
      child: Container(
        decoration: _pageDecoration(),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _BackHeader(pet: pet),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldCard(
                      children: [
                        _InfoRow(label: AppText.code, value: pet.code),
                        if (pet.age != null)
                          _InfoRow(
                            label: AppText.age,
                            value: '${pet.age} ${AppText.years}',
                          ),
                        if (pet.categoryName != null)
                          _InfoRow(
                            label: AppText.category,
                            value: pet.categoryName!,
                          ),
                        if (pet.genderName != null)
                          _InfoRow(
                            label: AppText.gender,
                            value: pet.genderName!,
                          ),
                        if (pet.colorName != null)
                          _InfoRow(label: AppText.color, value: pet.colorName!),
                      ],
                    ),
                    if (pet.description != null && pet.description!.isNotEmpty)
                      _InfoBlock(label: AppText.about, value: pet.description!),
                    if (pet.details != null && pet.details!.isNotEmpty)
                      _InfoBlock(
                        label: AppText.healthDetails,
                        value: pet.details!,
                      ),
                    if (pet.vaccinations.isNotEmpty) ...[
                      _BackSectionTitle(AppText.medicalRecords),
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
                    if (onEditPet != null || onDeletePet != null) ...[
                      SizedBox(height: 12.h),
                      _ActionRow(
                        onEditPet: onEditPet,
                        onDeletePet: onDeletePet,
                      ),
                    ],
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
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 48.w, 14.h),
      color: AppColors.current.primary,
      child: Row(
        children: [
          _PassportPhoto(imageUrl: pet.imageUrls.firstOrNull, size: 54.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  pet.categoryName ?? AppText.petPassport,
                  style: TextStyle(
                    color: Colors.white.withAlpha(190),
                    fontSize: 11.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          AppIcon.raw(
            Icons.verified_rounded,
            color: AppColors.current.gold,
            size: 22.w,
          ),
        ],
      ),
    );
  }
}

class _FieldCard extends StatelessWidget {
  final List<Widget> children;

  const _FieldCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.current.lightGray.withAlpha(70),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.current.lightGray),
      ),
      child: Column(children: children),
    );
  }
}

class _BackSectionTitle extends StatelessWidget {
  final String title;

  const _BackSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 16.h,
            decoration: BoxDecoration(
              color: AppColors.current.primary,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
          SizedBox(width: 7.w),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: AppColors.current.primary,
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
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
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          SizedBox(
            width: 92.w,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.current.midGray,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.current.text,
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
      padding: EdgeInsets.only(top: 12.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.current.lightGray),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: AppColors.current.primary,
                fontSize: 9.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                color: AppColors.current.text,
                fontSize: 11.sp,
                height: 1.35,
              ),
            ),
          ],
        ),
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
    final dateLabel =
        date != null
            ? '${date.day}/${date.month}/${date.year}'
            : AppText.dateUnknown;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.current.teal.withAlpha(16),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.current.teal.withAlpha(60)),
      ),
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: AppColors.current.teal.withAlpha(26),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: AppIcon.raw(
              Icons.vaccines_rounded,
              color: AppColors.current.teal,
              size: 16.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vaccination.name,
                  style: TextStyle(
                    color: AppColors.current.text,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
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

class _StatusToggleButton extends StatefulWidget {
  final int? adoptionStatus;
  final ValueChanged<int> onToggle;

  const _StatusToggleButton({
    required this.adoptionStatus,
    required this.onToggle,
  });

  @override
  State<_StatusToggleButton> createState() => _StatusToggleButtonState();
}

class _StatusToggleButtonState extends State<_StatusToggleButton> {
  late int currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.adoptionStatus ?? 0;
  }

  void _handleToggle() {
    final newStatus = currentStatus == 1 ? 0 : 1;
    setState(() => currentStatus = newStatus);
    widget.onToggle(newStatus);
  }

  @override
  Widget build(BuildContext context) {
    final isAvailable = currentStatus == 1;
    final color = isAvailable ? AppColors.current.red : AppColors.current.green;
    final icon =
        isAvailable ? Icons.visibility_off_rounded : Icons.pets_rounded;
    final label =
        isAvailable ? AppText.makePrivate : AppText.makeAvailableForAdoption;

    return GestureDetector(
      onTap: _handleToggle,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color.withAlpha(18),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: color.withAlpha(80)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon.raw(icon, color: color, size: 16.w),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final VoidCallback? onEditPet;
  final VoidCallback? onDeletePet;

  const _ActionRow({this.onEditPet, this.onDeletePet});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onEditPet != null)
          Expanded(
            child: _ActionButton(
              icon: Icons.edit_rounded,
              color: AppColors.current.primary,
              onTap: onEditPet!,
            ),
          ),
        if (onEditPet != null && onDeletePet != null) SizedBox(width: 10.w),
        if (onDeletePet != null)
          Expanded(
            child: _ActionButton(
              icon: Icons.delete_rounded,
              color: AppColors.current.red,
              onTap: onDeletePet!,
            ),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: color.withAlpha(18),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: color.withAlpha(80)),
        ),
        alignment: Alignment.center,
        child: AppIcon.raw(icon, color: color, size: 20.w),
      ),
    );
  }
}

class _DocumentField extends StatelessWidget {
  final String label;
  final String value;

  const _DocumentField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.current.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.current.midGray,
              fontSize: 8.sp,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: AppColors.current.text,
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _CodePlate extends StatelessWidget {
  final String code;

  const _CodePlate({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(7.r),
        border: Border.all(color: AppColors.current.lightGray),
      ),
      child: Text(
        code,
        style: TextStyle(
          color: AppColors.current.text,
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _VerifiedStamp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.08,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.current.teal, width: 1.3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon.raw(
              Icons.verified_rounded,
              color: AppColors.current.teal,
              size: 13.w,
            ),
            SizedBox(width: 4.w),
            Text(
              AppText.pettixBrand,
              style: TextStyle(
                color: AppColors.current.teal,
                fontSize: 8.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassportPhoto extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const _PassportPhoto({this.imageUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withAlpha(180), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: AppCachedImage(
          imageUrl: imageUrl ?? '',
          fit: BoxFit.cover,
          errorWidget: _PhotoPlaceholder(size: size),
          backgroundColor: AppColors.current.lightGray.withAlpha(70),
        ),
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  final double size;

  const _PhotoPlaceholder({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: AppColors.current.lightGray.withAlpha(70),
      child: AppIcon.raw(
        Icons.pets_rounded,
        color: AppColors.current.primary.withAlpha(90),
        size: size * 0.4,
      ),
    );
  }
}

BoxDecoration _pageDecoration() {
  return BoxDecoration(
    color: AppColors.current.white,
    borderRadius: BorderRadius.circular(18.r),
    border: Border.all(color: Colors.white.withAlpha(180)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withAlpha(45),
        blurRadius: 28,
        offset: const Offset(0, 10),
      ),
    ],
  );
}
