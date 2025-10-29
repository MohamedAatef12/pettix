import 'package:flutter/material.dart';

import '../widgets/pet_application/pet_application_body.dart';

class PetApplicationScreen extends StatelessWidget {
  const PetApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: PetApplicationBody());
  }
}
