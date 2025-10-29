import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';

class AdoptionTextField extends StatelessWidget {
  const AdoptionTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: CustomTextFormField(
        hintText: 'Search for pets ...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        fillColor: true,
        fillColorValue: AppColors.current.lightGray,

        leading: SvgPicture.asset(
          'assets/icons/search.svg',
          fit: BoxFit.scaleDown,
          color: AppColors.current.lightText,
        ),
        suffixIcon: Icon(
          Icons.filter_alt_rounded,
          color: AppColors.current.lightText,
        ),
      ),
    );
  }
}
