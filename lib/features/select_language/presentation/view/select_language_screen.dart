import 'package:flutter/material.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/select_language/presentation/view/widgets/select_language_body.dart';

class SelectLanguageScreen extends StatelessWidget {
  const SelectLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.white,
    body: SelectLanguageBody(),
    );

  }
}
