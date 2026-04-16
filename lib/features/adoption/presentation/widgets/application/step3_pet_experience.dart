import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/sized_box.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import '../../bloc/adoption_bloc.dart';
import '../../bloc/adoption_event.dart';
import '../../bloc/adoption_state.dart';
import 'step2_living_situation.dart'; // For CustomChoiceChip

class Step3PetExperience extends StatelessWidget {
  const Step3PetExperience({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: BlocBuilder<AdoptionBloc, AdoptionState>(
        builder: (context, state) {
          final bloc = context.read<AdoptionBloc>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Have you owned or cared for a pet before?",
                style: AppTextStyles.description,
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomChoiceChip(
                      label: "Yes",
                      selected: state.hasOwnedPetBefore == true,
                      onSelected: () => bloc.add(const UpdateHasOwnedPet(true)),
                    ),
                  ),
                  SizedBoxConstants.horizontalSmall,
                  Expanded(
                    child: CustomChoiceChip(
                      label: "No",
                      selected: state.hasOwnedPetBefore == false,
                      onSelected:
                          () => bloc.add(const UpdateHasOwnedPet(false)),
                    ),
                  ),
                ],
              ),
              if (state.hasOwnedPetBefore == true) ...[
                SizedBoxConstants.verticalLarge,
                Text("If yes, what type?", style: AppTextStyles.description),
                SizedBox(height: 12.h),
                CustomTextFormField(
                  controller: bloc.petTypeController,
                  onChanged: (val) => bloc.add(UpdatePetType(val)),
                  hintText: "Dog, Cat, etc.",
                  fillColor: true,
                  fillColorValue: AppColors.current.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.current.lightGray,
                      width: 1.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.current.lightGray,
                      width: 1.w,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.current.lightGray,
                      width: 1.w,
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
