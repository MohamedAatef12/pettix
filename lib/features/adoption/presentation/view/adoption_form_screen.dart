import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import '../../../../config/di/di.dart';
import '../../domain/entities/adoption_options_entity.dart';
import '../bloc/adoption_bloc.dart';
import '../bloc/adoption_event.dart';
import '../bloc/adoption_state.dart';

class AdoptionFormScreen extends StatelessWidget {
  final int? petId;
  const AdoptionFormScreen({super.key, this.petId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = getIt<AdoptionBloc>()..add(const FetchAdoptionOptions());
        if (petId != null) {
          bloc.add(SetPetId(petId!));
        }
        return bloc;
      },
      child: const AdoptionFormView(),
    );
  }
}

class AdoptionFormView extends StatelessWidget {
  const AdoptionFormView({super.key});

  void _submitForm(BuildContext context, AdoptionBloc bloc) {
    if (bloc.state.fullName.isEmpty ||
        bloc.state.email.isEmpty ||
        bloc.state.phoneNumber.isEmpty ||
        bloc.state.dateOfBirth.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }
    if (bloc.state.selectedLivingSituationId == null ||
        bloc.state.selectedResidenceTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all options')),
      );
      return;
    }
    if (!bloc.state.agreed || !bloc.state.termsAccepted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please agree to terms')));
      return;
    }

    bloc.add(const SubmitAdoptionForm());
  }

  Future<void> _pickDate(BuildContext context, AdoptionBloc bloc) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      bloc.add(SelectDateOfBirth(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AdoptionBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adoption Application'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.current.text,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<AdoptionBloc, AdoptionState>(
        listener: (context, state) {
          if (state.status == AdoptionStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Application Submitted Successfully!'),
              ),
            );
            context.pop();
          } else if (state.status == AdoptionStatus.submitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Submission Failed'),
              ),
            );
          } else if (state.status == AdoptionStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Error Loading Options'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == AdoptionStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.options != null) {
            return Stack(
              children: [
                AdoptionFormContent(
                  options: state.options!,
                  onSubmit: () => _submitForm(context, bloc),
                  onPickDate: () => _pickDate(context, bloc),
                ),
                if (state.status == AdoptionStatus.submitting)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          }

          if (state.status == AdoptionStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'Something went wrong'),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class AdoptionFormContent extends StatelessWidget {
  final AdoptionOptionsEntity options;
  final VoidCallback onSubmit;
  final VoidCallback onPickDate;

  const AdoptionFormContent({
    super.key,
    required this.options,
    required this.onSubmit,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdoptionBloc, AdoptionState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: context.read<AdoptionBloc>().fullNameController,
                hintText: 'Full Name',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBoxConstants.verticalSmall,
              CustomTextFormField(
                controller: context.read<AdoptionBloc>().emailController,
                hintText: 'Email',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBoxConstants.verticalSmall,
              CustomTextFormField(
                controller: context.read<AdoptionBloc>().phoneNumberController,
                hintText: 'Phone Number',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBoxConstants.verticalSmall,
              InkWell(
                onTap: onPickDate,
                child: IgnorePointer(
                  child: CustomTextFormField(
                    controller: context.read<AdoptionBloc>().dobController,
                    hintText: 'Date of Birth',
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ),
              SizedBoxConstants.verticalSmall,
              CustomTextFormField(
                controller: context.read<AdoptionBloc>().petTypeController,
                hintText: 'Pet Type',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBoxConstants.verticalSmall,
              _DropdownField(
                label: 'Living Situation',
                value: state.selectedLivingSituationId,
                items: options.livingSituations,
                onChanged:
                    (val) => context.read<AdoptionBloc>().add(
                      UpdateLivingSituation(val!),
                    ),
              ),
              SizedBoxConstants.verticalSmall,
              _DropdownField(
                label: 'Residence Type',
                value: state.selectedResidenceTypeId,
                items: options.residenceTypes,
                onChanged:
                    (val) => context.read<AdoptionBloc>().add(
                      UpdateResidenceType(val!),
                    ),
              ),
              SizedBoxConstants.verticalMedium,
              _ToggleRow(
                label: 'Has owned or cared for pet before?',
                value: state.hasOwnedPetBefore ?? false,
                onChanged:
                    (v) =>
                        context.read<AdoptionBloc>().add(UpdateHasOwnedPet(v!)),
              ),
              _CheckRow(
                label: 'I have read and understood everything',
                value: state.agreed,
                onChanged:
                    (v) => context.read<AdoptionBloc>().add(ToggleAgreement(v!)),
              ),
              _CheckRow(
                label: 'I agree to the terms',
                value: state.termsAccepted,
                onChanged:
                    (v) => context.read<AdoptionBloc>().add(
                      ToggleTermsAcceptance(v!),
                    ),
              ),
              SizedBoxConstants.verticalMedium,
              CustomFilledButton(
                onPressed: onSubmit,
                text: 'Submit Application',
                widthFactor: 1.0,
                heightFactor: 0.065,
                backgroundColor: AppColors.current.primary,
                textStyle: AppTextStyles.button.copyWith(
                  color: AppColors.current.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final int? value;
  final List<dynamic> items;
  final ValueChanged<int?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      hint: Text(label),
      items:
          items
              .map(
                (e) => DropdownMenuItem<int>(
                  value: e.id as int,
                  child: Text(e.name),
                ),
              )
              .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
        filled: true,
        fillColor: AppColors.current.lightGray,
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _CheckRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}
