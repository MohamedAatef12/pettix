import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/widgets/app_dropdown.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_event.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_state.dart';

class GenderDropdown extends StatelessWidget {
  const GenderDropdown({super.key});

  static final _items = [
    AppDropdownItem<int>(
      value: 1,
      label: AppText.male,
      icon: Icons.male_rounded,
      iconColor: const Color(0xFF5EA8DF),
    ),
    AppDropdownItem<int>(
      value: 2,
      label: AppText.female,
      icon: Icons.female_rounded,
      iconColor: const Color(0xFFE8A838),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (prev, curr) => prev.selectedGenderId != curr.selectedGenderId,
      builder: (context, state) {
        return AppDropdown<int>(
          hint: AppText.gender,
          prefixIcon: Icons.wc_rounded,
          items: _items,
          value: state.selectedGenderId,
          onChanged:
              (v) => context.read<ProfileBloc>().add(UpdateGenderEvent(v)),
        );
      },
    );
  }
}
