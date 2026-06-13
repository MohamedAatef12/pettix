import 'package:flutter/material.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/enums/app_enums.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_dropdown.dart';

/// Profile-style gender dropdown backed by the shared [Gender] enum values.
class PetGenderSelector extends StatelessWidget {
  final int? selected;
  final ValueChanged<int?> onSelected;

  const PetGenderSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      AppDropdownItem<int>(
        value: Gender.male.value,
        label: AppText.male,
        icon: Icons.male_rounded,
        iconColor: const Color(0xFF5EA8DF),
      ),
      AppDropdownItem<int>(
        value: Gender.female.value,
        label: AppText.female,
        icon: Icons.female_rounded,
        iconColor: const Color(0xFFE8A838),
      ),
    ];

    return AppDropdown<int>(
      hint: AppText.gender,
      prefixIcon: Icons.wc_rounded,
      prefixIconColor: AppColors.current.teal,
      items: options,
      value: selected,
      onChanged: onSelected,
    );
  }
}
