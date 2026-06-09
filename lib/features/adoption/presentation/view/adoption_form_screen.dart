import 'package:pettix/core/widgets/app_page_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/di/di.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/services/app_review_service.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/auth_toast.dart';
import '../../../../core/utils/custom_text_form_field.dart';
import '../../../../core/widgets/app_top_bar.dart';
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

class AdoptionFormView extends StatefulWidget {
  const AdoptionFormView({super.key});

  @override
  State<AdoptionFormView> createState() => _AdoptionFormViewState();
}

class _AdoptionFormViewState extends State<AdoptionFormView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _petTypeController = TextEditingController();

  int? _selectedLivingSituationId;
  int? _selectedResidenceTypeId;
  bool _hasOwnedPetBefore = false;
  bool _hasReadAndUnderstood = false;
  bool _agreesToTerms = false;

  DateTime? _selectedDate;

  String _formatDateInEnglish(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    _petTypeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = _formatDateInEnglish(picked);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedLivingSituationId == null ||
          _selectedResidenceTypeId == null) {
        AuthToast.showError(context, AppText.pleaseSelectAllOptions);
        return;
      }
      if (!_hasReadAndUnderstood || !_agreesToTerms) {
        AuthToast.showError(context, AppText.pleaseAgreeToTerms);
        return;
      }
      if (_selectedDate == null) {
        AuthToast.showError(context, AppText.pleaseSelectDateOfBirth);
        return;
      }

      final bloc = context.read<AdoptionBloc>();
      bloc.add(UpdateFullName(_fullNameController.text));
      bloc.add(UpdateEmail(_emailController.text));
      bloc.add(UpdatePhoneNumber(_phoneNumberController.text));
      bloc.add(UpdateDateOfBirth(_dateOfBirthController.text));
      bloc.add(UpdatePetType(_petTypeController.text));
      bloc.add(UpdateLivingSituation(_selectedLivingSituationId!));
      bloc.add(UpdateResidenceType(_selectedResidenceTypeId!));
      bloc.add(UpdateHasOwnedPet(_hasOwnedPetBefore));
      bloc.add(ToggleAgreement(_hasReadAndUnderstood));
      bloc.add(ToggleTermsAcceptance(_agreesToTerms));

      bloc.add(const SubmitAdoptionForm());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar.back(
        title: AppText.adoptionApplication,
        onBack: () => context.pop(),
      ),
      body: BlocConsumer<AdoptionBloc, AdoptionState>(
        listener: (context, state) async {
          if (state.status == AdoptionStatus.success) {
            AuthToast.showSuccess(
              context,
              AppText.applicationSubmittedSuccessfully,
            );
            await AppReviewService.requestAfterFirstAdoption(context);
            if (!context.mounted) return;
            context.pop();
          } else if (state.status == AdoptionStatus.submitError) {
            AuthToast.showError(
              context,
              state.errorMessage ?? AppText.submissionFailed,
            );
          } else if (state.status == AdoptionStatus.error) {
            AuthToast.showError(
              context,
              state.errorMessage ?? AppText.errorLoadingOptions,
            );
          }
        },
        builder: (context, state) {
          if (state.status == AdoptionStatus.loading) {
            return const AppPageShimmer();
          }

          if (state.options != null) {
            return Stack(
              children: [
                _buildForm(context, state.options!),
                if (state.status == AdoptionStatus.submitting)
                  const Center(child: CircularProgressIndicator()),
              ],
            );
          }

          if (state.status == AdoptionStatus.error) {
            return Center(child: Text(state.errorMessage ?? AppText.error));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, AdoptionOptionsEntity options) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              controller: _fullNameController,
              hintText: AppText.fullName,
              validator: (value) => value!.isEmpty ? AppText.required : null,
            ),
            SizedBox(height: 10.h),
            CustomTextFormField(
              controller: _emailController,
              hintText: AppText.email,
              validator: (value) => value!.isEmpty ? AppText.required : null,
            ),
            SizedBox(height: 10.h),
            CustomTextFormField(
              controller: _phoneNumberController,
              hintText: AppText.phoneNumber,
              validator: (value) => value!.isEmpty ? AppText.required : null,
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () => _selectDate(context),
              child: IgnorePointer(
                child: CustomTextFormField(
                  controller: _dateOfBirthController,
                  hintText: AppText.dateOfBirth,
                  validator:
                      (value) => value!.isEmpty ? AppText.required : null,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            CustomTextFormField(
              controller: _petTypeController,
              hintText: AppText.petType,
              validator: (value) => value!.isEmpty ? AppText.required : null,
            ),
            SizedBox(height: 10.h),
            DropdownButtonFormField<int>(
              initialValue: _selectedLivingSituationId,
              hint: Text(AppText.livingSituation),
              items:
                  options.livingSituations.map((e) {
                    return DropdownMenuItem(value: e.id, child: Text(e.name));
                  }).toList(),
              onChanged:
                  (val) => setState(() => _selectedLivingSituationId = val),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: AppColors.current.lightGray,
              ),
            ),
            SizedBox(height: 10.h),
            DropdownButtonFormField<int>(
              initialValue: _selectedResidenceTypeId,
              hint: Text(AppText.residenceType),
              items:
                  options.residenceTypes.map((e) {
                    return DropdownMenuItem(value: e.id, child: Text(e.name));
                  }).toList(),
              onChanged:
                  (val) => setState(() => _selectedResidenceTypeId = val),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: AppColors.current.lightGray,
              ),
            ),
            SizedBox(height: 20.h),
            SwitchListTile(
              title: Text(AppText.hasOwnedOrCaredForPetBefore),
              value: _hasOwnedPetBefore,
              onChanged: (val) => setState(() => _hasOwnedPetBefore = val),
            ),
            CheckboxListTile(
              title: Text(AppText.haveReadAndUnderstoodEverything),
              value: _hasReadAndUnderstood,
              onChanged: (val) => setState(() => _hasReadAndUnderstood = val!),
            ),
            CheckboxListTile(
              title: Text(AppText.agreeToTerms),
              value: _agreesToTerms,
              onChanged: (val) => setState(() => _agreesToTerms = val!),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.current.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppText.submitApplication,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
