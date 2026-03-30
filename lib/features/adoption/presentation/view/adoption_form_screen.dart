import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../config/di/di.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/custom_text_form_field.dart';
import '../../domain/entities/adoption_options_entity.dart';
import '../bloc/adoption_bloc.dart';
import '../bloc/adoption_event.dart';
import '../bloc/adoption_state.dart';

class AdoptionFormScreen extends StatelessWidget {
  const AdoptionFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AdoptionBloc>()..add(FetchAdoptionOptions()),
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
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedLivingSituationId == null ||
          _selectedResidenceTypeId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select all options')),
        );
        return;
      }
      if (!_hasReadAndUnderstood || !_agreesToTerms) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please agree to terms')));
        return;
      }
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Date of Birth')),
        );
        return;
      }


      context.read<AdoptionBloc>().add(SubmitAdoptionForm());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adoption Application')),
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
                _buildForm(context, state.options!),
                if (state.status == AdoptionStatus.submitting)
                  const Center(child: CircularProgressIndicator()),
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
              hintText: 'Full Name',
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 10.h),
            CustomTextFormField(
              controller: _emailController,
              hintText: 'Email',
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 10.h),
            CustomTextFormField(
              controller: _phoneNumberController,
              hintText: 'Phone Number',
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () => _selectDate(context),
              child: IgnorePointer(
                child: CustomTextFormField(
                  controller: _dateOfBirthController,
                  hintText: 'Date of Birth',
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            CustomTextFormField(
              controller: _petTypeController,
              hintText: 'Pet Type',
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            SizedBox(height: 10.h),
            DropdownButtonFormField<int>(
              initialValue: _selectedLivingSituationId,
              hint: const Text('Living Situation'),
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
              hint: const Text('Residence Type'),
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
              title: const Text('Has owned or cared for pet before?'),
              value: _hasOwnedPetBefore,
              onChanged: (val) => setState(() => _hasOwnedPetBefore = val),
            ),
            CheckboxListTile(
              title: const Text('I have read and understood everything'),
              value: _hasReadAndUnderstood,
              onChanged: (val) => setState(() => _hasReadAndUnderstood = val!),
            ),
            CheckboxListTile(
              title: const Text('I agree to the terms'),
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
                child: const Text(
                  'Submit Application',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
