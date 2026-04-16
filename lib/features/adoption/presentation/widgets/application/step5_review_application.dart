import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import '../../bloc/adoption_bloc.dart';
import '../../bloc/adoption_event.dart';
import '../../bloc/adoption_state.dart';

class StepReviewApplication extends StatelessWidget {
  const StepReviewApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBloc, AdoptionState>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
          children: [
            Text(
              'Almost there! Review your information before submitting.',
              style: AppTextStyles.smallDescription.copyWith(
                color: AppColors.current.midGray,
                height: 1.5,
              ),
            ),
            SizedBoxConstants.verticalMedium,
            _ReviewCard(
              title: 'Personal Information',
              icon: Icons.person_outline_rounded,
              step: 1,
              rows: [
                _ReviewRow(label: 'Full Name', value: state.fullName),
                _ReviewRow(label: 'Email', value: state.email),
                _ReviewRow(label: 'Phone', value: state.phoneNumber),
                _ReviewRow(label: 'Date of Birth', value: state.dateOfBirth),
              ],
            ),
            SizedBox(height: 12.h),
            _ReviewCard(
              title: 'Living Situation',
              icon: Icons.home_outlined,
              step: 2,
              rows: [
                _ReviewRow(
                  label: 'Living Situation',
                  value: _getLivingSituationName(state),
                ),
                _ReviewRow(
                  label: 'Type of Residence',
                  value: _getResidenceTypeName(state),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _ReviewCard(
              title: 'Pet Experience',
              icon: Icons.pets_rounded,
              step: 3,
              rows: [
                _ReviewRow(
                  label: 'Owned a pet before?',
                  value: state.hasOwnedPetBefore == true ? 'Yes' : 'No',
                ),
                if (state.hasOwnedPetBefore == true)
                  _ReviewRow(label: 'Type of pet', value: state.petType ?? '—'),
              ],
            ),
            SizedBoxConstants.verticalLarge,
            CustomFilledButton(
              onPressed:
                  () => context.read<AdoptionBloc>().add(
                    const SubmitAdoptionForm(),
                  ),
              text: 'Submit Application',
              heightFactor: 0.065,
              backgroundColor: AppColors.current.primary,
              textStyle: AppTextStyles.description.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.current.white,
              ),
            ),
          ],
        );
      },
    );
  }

  String _getLivingSituationName(AdoptionState state) {
    try {
      return state.options!.livingSituations
          .firstWhere((e) => e.id == state.selectedLivingSituationId)
          .name;
    } catch (_) {
      return '—';
    }
  }

  String _getResidenceTypeName(AdoptionState state) {
    try {
      return state.options!.residenceTypes
          .firstWhere((e) => e.id == state.selectedResidenceTypeId)
          .name;
    } catch (_) {
      return '—';
    }
  }
}

class _ReviewCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int step;
  final List<_ReviewRow> rows;

  const _ReviewCard({
    required this.title,
    required this.icon,
    required this.step,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.current.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 8.w, 12.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(7.w),
                  decoration: BoxDecoration(
                    color: AppColors.current.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    icon,
                    size: 16.w,
                    color: AppColors.current.primary,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.description.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed:
                      () => context.read<AdoptionBloc>().add(JumpToStep(step)),
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 18.w,
                    color: AppColors.current.primary,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Edit',
                ),
                SizedBox(width: 8.w),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.current.lightGray),
          // Rows
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Column(
              children:
                  rows
                      .map(
                        (r) => Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 110.w,
                                child: Text(
                                  r.label,
                                  style: AppTextStyles.smallDescription
                                      .copyWith(
                                        color: AppColors.current.midGray,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  r.value.isEmpty ? '—' : r.value,
                                  style: AppTextStyles.description.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewRow {
  final String label;
  final String value;

  const _ReviewRow({required this.label, required this.value});
}
