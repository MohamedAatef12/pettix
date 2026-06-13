import 'package:flutter/material.dart';
import 'package:pettix/features/my_pets/presentation/widgets/add_pet_form.dart';

/// Full-screen scaffold wrapping the [AddPetForm] body.
class AddPetScreen extends StatelessWidget {
  const AddPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: AddPetForm()),
    );
  }
}
