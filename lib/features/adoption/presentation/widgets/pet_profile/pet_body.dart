import 'package:flutter/cupertino.dart';
import 'package:pettix/features/adoption/presentation/widgets/pet_profile/pet_description.dart';
import 'package:pettix/features/adoption/presentation/widgets/pet_profile/pet_details.dart';
import 'package:pettix/features/adoption/presentation/widgets/pet_profile/pet_medical_history.dart';
import 'package:pettix/features/adoption/presentation/widgets/pet_profile/pet_photos.dart';

class PetBody extends StatelessWidget {
  const PetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        PetGallery(),
        PetDetails(),
        PetDescription(),
        PetMedicalHistory(),
      ],
    );
  }
}
