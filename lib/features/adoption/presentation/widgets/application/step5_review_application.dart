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
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            children: [
              Text(
                'Please review your information before submitting.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.current.midGray,
                ),
              ),
              SizedBoxConstants.verticalLarge,
              _ReviewSection(
                title: 'Personal Information',
                onEdit: () => context.read<AdoptionBloc>().add(JumpToStep(1)),
                items: [
                  'Full Name: ${state.fullName}',
                  'Email: ${state.email}',
                  'Phone: ${state.phoneNumber}',
                  'Date of Birth: ${state.dateOfBirth}',
                ],
              ),
              SizedBoxConstants.verticalMedium,
              _ReviewSection(
                title: 'Living Situation',
                onEdit: () => context.read<AdoptionBloc>().add(JumpToStep(2)),
                items: [
                  'Living Situation: ${_getLivingSituationName(state)}',
                  'Type of Residence: ${_getResidenceTypeName(state)}',
                ],
              ),
              SizedBoxConstants.verticalMedium,
              _ReviewSection(
                title: 'Pet Experience',
                onEdit: () => context.read<AdoptionBloc>().add(JumpToStep(3)),
                items: [
                  'Owned a pet before?: ${state.hasOwnedPetBefore == true ? 'Yes' : 'No'}',
                  if (state.hasOwnedPetBefore == true)
                    'Kind of pet: ${state.petType}',
                ],
              ),
              SizedBoxConstants.verticalLarge,
              CustomFilledButton(
                onPressed: () => context
                    .read<AdoptionBloc>()
                    .add(const SubmitAdoptionForm()),
                text: 'Submit Application',
                heightFactor: 0.06,
                backgroundColor: AppColors.current.primary,
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.current.white,
                ),
              ),
              SizedBoxConstants.verticalExtraLarge,
            ],
          ),
        );
      },
    );
  }

  String _getLivingSituationName(AdoptionState state) {
    if (state.options == null || state.options!.livingSituations.isEmpty) {
      return 'Unknown';
    }
    try {
      return state.options!.livingSituations
          .firstWhere((e) => e.id == state.selectedLivingSituationId)
          .name;
    } catch (_) {
      return state.options!.livingSituations.first.name;
    }
  }

  String _getResidenceTypeName(AdoptionState state) {
    if (state.options == null || state.options!.residenceTypes.isEmpty) {
      return 'Unknown';
    }
    try {
      return state.options!.residenceTypes
          .firstWhere((e) => e.id == state.selectedResidenceTypeId)
          .name;
    } catch (_) {
      return state.options!.residenceTypes.first.name;
    }
  }
}

class _ReviewSection extends StatelessWidget {
  final String title;
  final VoidCallback onEdit;
  final List<String> items;

  const _ReviewSection({
    required this.title,
    required this.onEdit,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyTitle.copyWith(
                fontSize: 15.sp,
                color: AppColors.current.text,
              ),
            ),
            GestureDetector(
              onTap: onEdit,
              child: Icon(
                Icons.mode_edit_outline_outlined,
                size: 20.w,
                color: AppColors.current.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.current.lightBlue,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items
                .map(
                  (item) => Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.current.lightText,
                        height: 1.5,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
