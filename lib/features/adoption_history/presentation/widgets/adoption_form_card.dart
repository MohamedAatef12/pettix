import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/enums/app_enums.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';

/// Returns colour and label for each [AdoptionFormStatus] value.
({Color bg, Color text, String label}) adoptionStatusStyle(int statusValue) {
  final status = AdoptionFormStatus.fromValue(statusValue);
  return switch (status) {
    AdoptionFormStatus.pending => (
      bg: const Color(0xFFFFF3CD),
      text: const Color(0xFF856404),
      label: 'Pending',
    ),
    AdoptionFormStatus.approved => (
      bg: const Color(0xFFD1FAE5),
      text: const Color(0xFF065F46),
      label: 'Approved',
    ),
    AdoptionFormStatus.rejected => (
      bg: const Color(0xFFFFE4E4),
      text: const Color(0xFF991B1B),
      label: 'Rejected',
    ),
    AdoptionFormStatus.cancelled => (
      bg: const Color(0xFFF3F4F6),
      text: const Color(0xFF6B7280),
      label: 'Cancelled',
    ),
    null => (
      bg: const Color(0xFFF3F4F6),
      text: const Color(0xFF6B7280),
      label: 'Unknown',
    ),
  };
}

/// Card displayed in each tab list row.
class AdoptionFormCard extends StatelessWidget {
  final AdoptionFormEntity form;

  /// When [true] this card belongs to the "owner" tab and shows the
  /// applicant's name instead of the pet name in the subtitle.
  final bool isOwnerView;
  final VoidCallback onTap;

  const AdoptionFormCard({
    super.key,
    required this.form,
    required this.isOwnerView,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = adoptionStatusStyle(form.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              _AvatarBlock(petName: form.petName),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            form.petName ?? 'Pet #${form.petId ?? '—'}',
                            style: TextStyle(
                              color: AppColors.current.text,
                              fontSize: 16.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _StatusBadge(style: style),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          isOwnerView ? Icons.person_outline_rounded : Icons.email_outlined,
                          size: 14.sp,
                          color: AppColors.current.midGray,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            isOwnerView ? 'By: ${form.fullName}' : form.email,
                            style: TextStyle(
                              color: AppColors.current.midGray,
                              fontSize: 12.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (form.livingSituation != null || form.typeOfResidence != null) ...[
                      SizedBox(height: 10.h),
                      _TagRow(
                        items: [
                          if (form.livingSituation != null)
                            (label: form.livingSituation!, icon: Icons.home_work_outlined),
                          if (form.typeOfResidence != null)
                            (label: form.typeOfResidence!, icon: Icons.location_city_outlined),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.current.blueGray,
                size: 24.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarBlock extends StatelessWidget {
  final String? petName;

  const _AvatarBlock({this.petName});

  @override
  Widget build(BuildContext context) {
    final initials =
        petName != null && petName!.isNotEmpty
            ? petName![0].toUpperCase()
            : '?';

    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.current.primary.withOpacity(0.8),
            AppColors.current.primary,
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.current.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pets_rounded,
              color: AppColors.current.white.withOpacity(0.6),
              size: 16.sp,
            ),
            Text(
              initials,
              style: TextStyle(
                color: AppColors.current.white,
                fontSize: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ({Color bg, Color text, String label}) style;

  const _StatusBadge({required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: style.text.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Text(
        style.label,
        style: TextStyle(
          color: style.text,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  final List<({String label, IconData icon})> items;

  const _TagRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items
            .map(
              (item) => Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.current.lightBlue,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.icon,
                      size: 12.sp,
                      color: AppColors.current.primary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      item.label,
                      style: TextStyle(
                        color: AppColors.current.primary,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

