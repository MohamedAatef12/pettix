import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/themes/app_colors.dart';
import '../../bloc/adoption_bloc.dart';
import '../../bloc/adoption_event.dart';
import '../../bloc/adoption_state.dart';

class Step4Agreements extends StatelessWidget {
  const Step4Agreements({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: BlocBuilder<AdoptionBloc, AdoptionState>(
        builder: (context, state) {
          final bloc = context.read<AdoptionBloc>();
          return ListView(
            children: [
              Text(
                'I Understand that:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: AppColors.current.text,
                ),
              ),
              SizedBoxConstants.verticalSmall,
              const _AgreementPoint(
                text:
                    'Pettix is a platform to connect pet lovers, adopters, clinics, and stores, but it does not replace professional veterinary advice.',
              ),
              SizedBoxConstants.verticalSmall,
              const _AgreementPoint(
                text:
                    'Any shared content in the community section is the responsibility of the user who posts it.',
              ),
              SizedBoxConstants.verticalLarge,
              Text(
                'I Agree to:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  color: AppColors.current.text,
                ),
              ),
              SizedBoxConstants.verticalSmall,
              const _AgreementPoint(
                text:
                    'Use Pettix responsibly and respectfully, without harmful or inappropriate behavior.',
              ),
              SizedBoxConstants.verticalSmall,
              const _AgreementPoint(
                text:
                    'Provide accurate and truthful information when creating my profile or posting.',
              ),
              SizedBoxConstants.verticalLarge,
              _StyledCheckbox(
                value: state.agreed,
                label: 'I have read and understood the points above.',
                onChanged: (v) => bloc.add(ToggleAgreement(v!)),
              ),
              SizedBoxConstants.verticalSmall,
              _StyledCheckbox(
                value: state.termsAccepted,
                label: 'I agree to all the terms and conditions.',
                onChanged: (v) => bloc.add(ToggleTermsAcceptance(v!)),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AgreementPoint extends StatelessWidget {
  final String text;

  const _AgreementPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          margin: EdgeInsets.only(top: 6.h, left: 8.w, right: 10.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.current.primary,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              height: 1.5,
              fontSize: 14.sp,
              color: AppColors.current.lightText,
            ),
          ),
        ),
      ],
    );
  }
}

class _StyledCheckbox extends StatelessWidget {
  final bool value;
  final String label;
  final ValueChanged<bool?> onChanged;

  const _StyledCheckbox({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        activeColor: AppColors.current.primary,
        checkColor: AppColors.current.white,
        side: BorderSide(color: AppColors.current.lightGray, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
        value: value,
        onChanged: onChanged,
        title: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.current.lightText,
          ),
        ),
      ),
    );
  }
}
