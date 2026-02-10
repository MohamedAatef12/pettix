import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              Text(
                "Review Your Application",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff3F425A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please review your information before submitting.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(
                context,
                "Personal Information",
                () => _jumpToStep(context, 1),
              ),
              const SizedBox(height: 8),
              _buildInfoCard([
                "Full Name: ${state.fullName}",
                "Email: ${state.email}",
                "Phone Number: ${state.phoneNumber}",
                "Date Of Birth: ${state.dateOfBirth}",
              ]),
              const SizedBox(height: 16),
              _buildSectionHeader(
                context,
                "Living Situation",
                () => _jumpToStep(context, 2),
              ),
              const SizedBox(height: 8),
              _buildInfoCard([
                "Living Situation: ${_getLivingSituationName(state)}",
                "Type of Residence: ${_getResidenceTypeName(state)}",
              ]),
              const SizedBox(height: 16),
              _buildSectionHeader(
                context,
                "Pet Experience",
                () => _jumpToStep(context, 3),
              ),
              const SizedBox(height: 8),
              _buildInfoCard([
                "Have you owned or cared with a pet before?: ${state.hasOwnedPetBefore == true ? 'Yes' : 'No'}",
                if (state.hasOwnedPetBefore == true)
                  "Kind Of Pet: ${state.petType}",
              ]),
              const SizedBox(height: 30),
              CustomFilledButton(
                onPressed: () {
                  context.read<AdoptionBloc>().add(const SubmitAdoptionForm());
                },
                text: "Submit Application",
                heightFactor: 0.06,
                backgroundColor: const Color(0xff5379B2),
                textStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    VoidCallback onEdit,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff3F425A),
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          child: const Icon(
            Icons.mode_edit_outline_outlined,
            size: 20,
            color: Color(0xff4A4C68),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(List<String> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xffF0E8DB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(40.r),
          bottomLeft: Radius.circular(8.r),
          bottomRight: Radius.circular(40.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff4A4C68),
                    height: 1.5,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  void _jumpToStep(BuildContext context, int step) {
    context.read<AdoptionBloc>().add(JumpToStep(step));
  }

  String _getLivingSituationName(AdoptionState state) {
    // Determine the living situation name safely
    if (state.options != null && state.options!.livingSituations.isNotEmpty) {
      try {
        final item = state.options!.livingSituations.firstWhere(
          (element) => element.id == state.selectedLivingSituationId,
        );
        return item.name;
      } catch (e) {
        return state.options!.livingSituations.first.name;
      }
    }
    return "Unknown";
  }

  String _getResidenceTypeName(AdoptionState state) {
    if (state.options != null && state.options!.residenceTypes.isNotEmpty) {
      try {
        final item = state.options!.residenceTypes.firstWhere(
          (element) => element.id == state.selectedResidenceTypeId,
        );
        return item.name;
      } catch (e) {
        return state.options!.residenceTypes.first.name;
      }
    }
    return "Unknown";
  }
}
