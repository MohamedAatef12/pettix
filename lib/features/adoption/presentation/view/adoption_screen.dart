import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/adoption_body.dart';

class AdoptionScreen extends StatelessWidget {
  const AdoptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFF),
      body: SafeArea(child: AdoptionBody()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.applications);
        },
        label: const Text('Adopt a Pet'),
        icon: const Icon(Icons.pets),
        backgroundColor: const Color(
          0xFF8B80F8,
        ), // Using a purple-ish color or from AppColors
      ),
    );
  }
}
