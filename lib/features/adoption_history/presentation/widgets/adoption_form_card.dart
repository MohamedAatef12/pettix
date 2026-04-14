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
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            _PetIconBlock(petName: form.petName),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            form.petName ?? 'Pet #${form.petId ?? '—'}',
                            style: TextStyle(
                              color: AppColors.current.text,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _StatusBadge(style: style),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      isOwnerView ? 'By: ${form.fullName}' : form.email,
                      style: TextStyle(
                        color: AppColors.current.midGray,
                        fontSize: 11.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (form.livingSituation != null) ...[
                      SizedBox(height: 6.h),
                      _TagRow(
                        items: [
                          form.livingSituation!,
                          if (form.typeOfResidence != null)
                            form.typeOfResidence!,
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 14.w),
              child: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.current.blueGray,
                size: 20.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PetIconBlock extends StatelessWidget {
  final String? petName;

  const _PetIconBlock({this.petName});

  @override
  Widget build(BuildContext context) {
    final initials =
        petName != null && petName!.isNotEmpty
            ? petName![0].toUpperCase()
            : '?';

    return Container(
      width: 56.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.current.primary.withAlpha(20),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          bottomLeft: Radius.circular(16.r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets_rounded,
            color: AppColors.current.primary.withAlpha(180),
            size: 18.w,
          ),
          SizedBox(height: 4.h),
          Text(
            initials,
            style: TextStyle(
              color: AppColors.current.primary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        style.label,
        style: TextStyle(
          color: style.text,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TagRow extends StatelessWidget {
  final List<String> items;

  const _TagRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          items
              .map(
                (tag) => Container(
                  margin: EdgeInsets.only(right: 6.w),
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.current.lightBlue,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: AppColors.current.primary,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}
