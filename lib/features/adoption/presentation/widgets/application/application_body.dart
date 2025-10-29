import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';

class Step1PersonalInfo extends StatelessWidget {
  const Step1PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              "Full Name",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.current.gray.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 5),
            CustomTextFormField(
              hintText: "My name is",
              fillColor: true,
              fillColorValue: AppColors.current.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xffF0E8DB), width: 1.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xffF0E8DB), width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xffF0E8DB), width: 1.w),
              ),
            ),
            SizedBox(height: 12),

            Text(
              "Email",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.current.gray.withOpacity(0.5),
              ),
            ),

            SizedBox(height: 5),
            CustomTextFormField(
              hintText: "example@gmail.com",
              fillColor: true,
              fillColorValue: AppColors.current.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xffF0E8DB), width: 1.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xffF0E8DB), width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xffF0E8DB), width: 1.w),
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Phone Number",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.current.gray.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 5),
            CustomTextFormField(
              hintText: "+1 234 567 890",

              fillColor: true,
              fillColorValue: AppColors.current.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xffF0E8DB), width: 1.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xffF0E8DB), width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xffF0E8DB), width: 1.w),
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Date of Birth ",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.current.gray.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 5),
            CustomTextFormField(
              hintText: "Date of Birth",
              fillColor: true,
              fillColorValue: AppColors.current.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xffF0E8DB), width: 1.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xffF0E8DB), width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xffF0E8DB), width: 1.w),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Step2LivingSituation extends StatefulWidget {
  const Step2LivingSituation({super.key});

  @override
  State<Step2LivingSituation> createState() => _Step2LivingSituationState();
}

class _Step2LivingSituationState extends State<Step2LivingSituation> {
  String? livingSituation;

  String? residenceType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Living Situation", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 12,

            children: [
              Expanded(
                child: CustomChoiceChip(
                  label: "House",
                  selected: livingSituation == "House",
                  onSelected: () => setState(() => livingSituation = "House"),
                ),
              ),
              Expanded(
                child: CustomChoiceChip(
                  label: "Apartment",
                  selected: livingSituation == "Apartment",
                  onSelected:
                      () => setState(() => livingSituation = "Apartment"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text("Type of Residence", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 12,

            children: [
              Expanded(
                child: CustomChoiceChip(
                  label: "Rent",
                  selected: residenceType == "Rent",
                  onSelected: () => setState(() => residenceType = "Rent"),
                ),
              ),
              Expanded(
                child: CustomChoiceChip(
                  label: "Own",
                  selected: residenceType == "Own",
                  onSelected: () => setState(() => residenceType = "Own"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Step3PetExperience extends StatefulWidget {
  const Step3PetExperience({super.key});

  @override
  State<Step3PetExperience> createState() => _Step3PetExperienceState();
}

class _Step3PetExperienceState extends State<Step3PetExperience> {
  String? ownedPet;

  String? petType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Have you owned or cared for a pet before?",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 12,
            children: [
              Expanded(
                child: CustomChoiceChip(
                  label: "Yes",
                  selected: ownedPet == "Yes",
                  onSelected: () => setState(() => ownedPet = "Yes"),
                ),
              ),
              Expanded(
                child: CustomChoiceChip(
                  label: "No",
                  selected: ownedPet == "No",
                  onSelected: () => setState(() => ownedPet = "No"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text("If yes, what type?", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 12,
            children: [
              Expanded(
                child: CustomChoiceChip(
                  label: "Dog",
                  selected: petType == "Dog",
                  onSelected: () => setState(() => petType = "Dog"),
                ),
              ),
              Expanded(
                child: CustomChoiceChip(
                  label: "Cat",
                  selected: petType == "Cat",
                  onSelected: () => setState(() => petType = "Cat"),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          CustomChoiceChip(
            label: "Other",
            selected: petType == "Other",
            onSelected: () => setState(() => petType = "Other"),
          ),
        ],
      ),
    );
  }
}

class Step4Agreements extends StatefulWidget {
  final bool agreed;
  final bool termsAccepted;
  final ValueChanged<bool> onAgreedChanged;
  final ValueChanged<bool> onTermsChanged;

  const Step4Agreements({
    super.key,
    required this.agreed,
    required this.termsAccepted,
    required this.onAgreedChanged,
    required this.onTermsChanged,
  });

  @override
  State<Step4Agreements> createState() => Step4AgreementsState();
}

class Step4AgreementsState extends State<Step4Agreements> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          const Text(
            "I Understand that:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "• Pettix is a platform to connect pet lovers, adopters, clinics, and stores, but it does not replace professional veterinary advice.",
              style: TextStyle(height: 1.5, fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "• Any shared content in the community section is the responsibility of the user who posts it.",
              style: TextStyle(height: 1.5, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "I Agree to:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "• Use Pettix responsibly and respectfully, without harmful or inappropriate behavior.",
              style: TextStyle(height: 1.5, fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "• Provide accurate and truthful information when creating my profile or posting.",
              style: TextStyle(height: 1.5, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: const Color(0xff5379B2),
                  checkColor: Colors.white,
                  side: const BorderSide(color: Color(0xffD0D5DD), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  value: widget.agreed,
                  onChanged: (v) => widget.onAgreedChanged(v!),
                  title: const Text(
                    "I have read and understood the points above.",
                    style: TextStyle(color: Color(0xff475467)),
                  ),
                ),
              ),
              Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: const Color(0xff5379B2),
                  checkColor: Colors.white,
                  side: const BorderSide(color: Color(0xffD0D5DD), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  value: widget.termsAccepted,
                  onChanged: (v) => widget.onTermsChanged(v!),
                  title: const Text(
                    "I agree to all the terms and conditions.",
                    style: TextStyle(color: Color(0xff475467)),
                  ),
                ),
              ),
            ],
          ),
        ],
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
        height: 60.h,
        decoration: BoxDecoration(
          color:
              selected
                  ? const Color(0xff5379B2).withOpacity(0.1)
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
