import 'package:flutter/material.dart';
import 'package:pettix/core/themes/app_colors.dart';

class AdoptionScreen extends StatelessWidget {
  const AdoptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightGray,
      body: Center(
        child: Text('Adoption Screen'),
      ),
    );
  }
}
