import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/enums/app_enums.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/adoption_history/domain/entities/adoption_form_entity.dart';
import 'package:pettix/features/adoption_history/presentation/widgets/adoption_form_card.dart';

/// Full detail view for a single adoption form.
/// [isOwnerView] controls whether Accept / Reject action buttons are shown.
class AdoptionFormDetailBody extends StatelessWidget {
  final AdoptionFormEntity form;
  final bool isOwnerView;

  const AdoptionFormDetailBody({
    super.key,
    required this.form,
    required this.isOwnerView,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DetailHeader(form: form),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PetInfoCard(form: form),
                SizedBox(height: 16.h),
                _SectionTitle('Applicant'),
                SizedBox(height: 10.h),
                _InfoGroup(rows: [
                  _InfoRow(
                    icon: Icons.person_outline_rounded,
                    iconColor: AppColors.current.primary,
                    label: 'Full Name',
                    value: form.fullName,
                  ),
                  _InfoRow(
                    icon: Icons.email_outlined,
                    iconColor: const Color(0xFF5EA8DF),
                    label: 'Email',
                    value: form.email,
                  ),
                  if (form.phoneNumber != null)
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      iconColor: const Color(0xFF56C590),
                      label: 'Phone',
                      value: form.phoneNumber!,
                    ),
                  if (form.dateOfBirth != null)
                    _InfoRow(
                      icon: Icons.cake_outlined,
                      iconColor: const Color(0xFFE8A838),
                      label: 'Date of Birth',
                      value: _formatDate(form.dateOfBirth!),
                    ),
                ]),
                SizedBox(height: 16.h),
                _SectionTitle('Living Situation'),
                SizedBox(height: 10.h),
                _InfoGroup(rows: [
                  if (form.livingSituation != null)
                    _InfoRow(
                      icon: Icons.home_outlined,
                      iconColor: const Color(0xFF7A6FD8),
                      label: 'Housing',
                      value: form.livingSituation!,
                    ),
                  if (form.typeOfResidence != null)
                    _InfoRow(
                      icon: Icons.vpn_key_outlined,
                      iconColor: AppColors.current.gold,
                      label: 'Residence',
                      value: form.typeOfResidence!,
                    ),
                  _InfoRow(
                    icon: Icons.pets_rounded,
                    iconColor: AppColors.current.teal,
                    label: 'Owned a pet before',
                    value: form.hasOwnedOrCaredForPetBefore ? 'Yes' : 'No',
                  ),
                  _InfoRow(
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: AppColors.current.green,
                    label: 'Agrees to terms',
                    value: form.agreesToTerms ? 'Yes' : 'No',
                  ),
                ]),
                SizedBox(height: 24.h),
                if (isOwnerView) _ActionButtons(form: form),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _DetailHeader extends StatelessWidget {
  final AdoptionFormEntity form;

  const _DetailHeader({required this.form});

  @override
  Widget build(BuildContext context) {
    final style = adoptionStatusStyle(form.status);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.current.primary, const Color(0xFF2A4E8F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.w, 8.h, 20.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.pets_rounded,
                            color: AppColors.current.gold, size: 16.w),
                        SizedBox(width: 6.w),
                        Text(
                          'Form #${form.id}',
                          style: TextStyle(
                            color: Colors.white.withAlpha(180),
                            fontSize: 11.sp,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      form.petName ?? 'Unknown Pet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: style.bg,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        style.label,
                        style: TextStyle(
                          color: style.text,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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

// ─── Pet info card ────────────────────────────────────────────────────────────

class _PetInfoCard extends StatelessWidget {
  final AdoptionFormEntity form;

  const _PetInfoCard({required this.form});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.current.primary.withAlpha(15),
            AppColors.current.lightBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
            color: AppColors.current.primary.withAlpha(40), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.current.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.pets_rounded,
                color: AppColors.current.primary, size: 24.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  form.petName ?? 'Unknown Pet',
                  style: TextStyle(
                    color: AppColors.current.text,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (form.petId != null)
                  Text(
                    'Pet ID: ${form.petId}',
                    style: TextStyle(
                      color: AppColors.current.midGray,
                      fontSize: 11.sp,
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

// ─── Shared section components ────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 3.w, height: 16.h, color: AppColors.current.primary),
        SizedBox(width: 8.w),
        Text(
          text.toUpperCase(),
          style: AppTextStyles.smallDescription.copyWith(
            color: AppColors.current.primary,
            fontSize: 10.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _InfoGroup extends StatelessWidget {
  final List<Widget> rows;
  const _InfoGroup({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: rows.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          indent: 52.w,
          color: AppColors.current.lightGray,
        ),
        itemBuilder: (_, i) => rows[i],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.current.midGray,
                    fontSize: 10.sp,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.current.text,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
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

// ─── Accept / Reject buttons (owner view, pending only) ───────────────────────

class _ActionButtons extends StatelessWidget {
  final AdoptionFormEntity form;

  const _ActionButtons({required this.form});

  @override
  Widget build(BuildContext context) {
    final status = AdoptionFormStatus.fromValue(form.status);
    final isPending = status == AdoptionFormStatus.pending;

    if (!isPending) return const SizedBox.shrink();

    return Column(
      children: [
        _SectionTitle('Review Application'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                label: 'Accept',
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.current.green,
                onTap: () => _confirmAction(
                  context,
                  title: 'Accept Application',
                  message:
                      'Are you sure you want to accept the application for ${form.petName}?',
                  confirm: 'Accept',
                  confirmColor: AppColors.current.green,
                  onConfirm: () {
                    // TODO: call update status endpoint with status=2 (approved)
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _ActionButton(
                label: 'Reject',
                icon: Icons.cancel_outlined,
                color: AppColors.current.red,
                outlined: true,
                onTap: () => _confirmAction(
                  context,
                  title: 'Reject Application',
                  message:
                      'Are you sure you want to reject the application for ${form.petName}?',
                  confirm: 'Reject',
                  confirmColor: AppColors.current.red,
                  onConfirm: () {
                    // TODO: call update status endpoint with status=3 (rejected)
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _confirmAction(
    BuildContext context, {
    required String title,
    required String message,
    required String confirm,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r)),
        title: Text(title,
            style: TextStyle(
                fontSize: 16.sp, fontWeight: FontWeight.w700)),
        content: Text(message,
            style: TextStyle(
                color: AppColors.current.midGray, fontSize: 13.sp)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel',
                style: TextStyle(color: AppColors.current.midGray)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
            ),
            child: Text(confirm,
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool outlined;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: color, width: 1.5),
          boxShadow: outlined
              ? []
              : [
                  BoxShadow(
                    color: color.withAlpha(60),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: outlined ? color : Colors.white, size: 18.w),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: outlined ? color : Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
