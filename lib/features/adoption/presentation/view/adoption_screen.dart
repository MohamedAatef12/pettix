import 'package:flutter/material.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/adoption_body.dart';

class AdoptionScreen extends StatelessWidget {
  const AdoptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFF),
      body: SafeArea(child: AdoptionBody()),
    );
  }
}
