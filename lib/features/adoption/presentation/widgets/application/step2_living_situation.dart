import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/adoption_bloc.dart';
import '../../bloc/adoption_event.dart';
import '../../bloc/adoption_state.dart';

class Step2LivingSituation extends StatelessWidget {
  const Step2LivingSituation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: BlocBuilder<AdoptionBloc, AdoptionState>(
        builder: (context, state) {
          final options = state.options;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Living Situation", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              if (options != null && options.livingSituations.isNotEmpty) ...[
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      options.livingSituations.map((e) {
                        return CustomChoiceChip(
                          label: e.name,
                          selected: state.selectedLivingSituationId == e.id,
                          onSelected:
                              () => context.read<AdoptionBloc>().add(
                                UpdateLivingSituation(e.id),
                              ),
                        );
                      }).toList(),
                ),
              ] else ...[
                const Text("Loading or no options available"),
              ],
              const SizedBox(height: 30),
              const Text("Type of Residence", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              if (options != null && options.residenceTypes.isNotEmpty) ...[
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      options.residenceTypes.map((e) {
                        return CustomChoiceChip(
                          label: e.name,
                          selected: state.selectedResidenceTypeId == e.id,
                          onSelected:
                              () => context.read<AdoptionBloc>().add(
                                UpdateResidenceType(e.id),
                              ),
                        );
                      }).toList(),
                ),
              ] else ...[
                const Text("Loading or no options available"),
              ],
            ],
          );
        },
      ),
    );
  }
}

class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onSelected;

  const CustomChoiceChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        height: 60.h,
        decoration: BoxDecoration(
          color:
              selected
                  ? const Color(0xff5379B2).withValues(alpha: 0.1)
                  : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? const Color(0xff5379B2) : const Color(0xffD0D5DD),
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xff5379B2) : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
