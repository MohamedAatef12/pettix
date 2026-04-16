import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import '../../bloc/adoption_bloc.dart';
import '../../bloc/adoption_event.dart';
import '../../bloc/adoption_state.dart';

class Step4Agreements extends StatelessWidget {
  const Step4Agreements({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBloc, AdoptionState>(
      builder: (context, state) {
        final bloc = context.read<AdoptionBloc>();
        return ListView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
          children: [
            // ── Understanding block ──────────────────────────────────────
            _SectionCard(
              title: 'I Understand that:',
              icon: Icons.info_outline_rounded,
              iconColor: AppColors.current.primary,
              children: const [
                _AgreementPoint(
                  text:
                      'Pettix connects pet lovers, adopters, clinics and stores — it does not replace professional veterinary advice.',
                ),
                _AgreementPoint(
                  text:
                      'Any content shared in the community is the responsibility of the user who posts it.',
                ),
              ],
            ),
            SizedBoxConstants.verticalSmall,
            // ── Agreement block ──────────────────────────────────────────
            _SectionCard(
              title: 'I Agree to:',
              icon: Icons.handshake_outlined,
              iconColor: AppColors.current.green,
              children: const [
                _AgreementPoint(
                  text:
                      'Use Pettix responsibly and respectfully, without harmful or inappropriate behaviour.',
                ),
                _AgreementPoint(
                  text:
                      'Provide accurate and truthful information when creating my profile or posting.',
                ),
              ],
            ),
            SizedBoxConstants.verticalMedium,
            // ── Checkboxes ───────────────────────────────────────────────
            _CheckCard(
              value: state.agreed,
              label: 'I have read and understood everything above.',
              onChanged: (v) => bloc.add(ToggleAgreement(v!)),
            ),
            SizedBox(height: 10.h),
            _CheckCard(
              value: state.termsAccepted,
              label: 'I agree to the terms and conditions.',
              onChanged: (v) => bloc.add(ToggleTermsAcceptance(v!)),
            ),
          ],
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.current.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.w, color: iconColor),
              SizedBox(width: 8.w),
              Text(
                title,
                style: AppTextStyles.description.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }
}

class _AgreementPoint extends StatelessWidget {
  final String text;

  const _AgreementPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.h, right: 10.w),
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.current.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.smallDescription.copyWith(
                height: 1.55,
                color: AppColors.current.lightText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckCard extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool?> onChanged;

  const _CheckCard({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color:
              value
                  ? AppColors.current.primary.withValues(alpha: 0.07)
                  : AppColors.current.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color:
                value ? AppColors.current.primary : AppColors.current.lightGray,
            width: value ? 1.8 : 1.2,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                color:
                    value ? AppColors.current.primary : AppColors.current.white,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color:
                      value
                          ? AppColors.current.primary
                          : AppColors.current.lightGray,
                  width: 1.5,
                ),
              ),
              child:
                  value
                      ? Icon(
                        Icons.check_rounded,
                        size: 14.w,
                        color: AppColors.current.white,
                      )
                      : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.smallDescription.copyWith(
                  color:
                      value
                          ? AppColors.current.text
                          : AppColors.current.lightText,
                  fontWeight: value ? FontWeight.w600 : FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
