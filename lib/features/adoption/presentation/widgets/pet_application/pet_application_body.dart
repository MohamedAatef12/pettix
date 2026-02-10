import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_bloc.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_event.dart';

class PetApplicationBody extends StatelessWidget {
  const PetApplicationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              child: SvgPicture.asset(
                'assets/images/adopt_animal.svg',
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.06,
              left: 10,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
                onTap: () {
                  context.pop();
                },
                child: SvgPicture.asset('assets/icons/backButton.svg'),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.07,
              right: MediaQuery.of(context).size.width / 2.9,
              child: const Text(
                'Adopt Charlie',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F425A),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Ready to welcome Charlie at your home ?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Thank you for choosing to adopt Charlie! to ensure right choice, we should ask you a few questions',
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'What to Expect',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Thank you for choosing to adopt Charlie! to ensure right choice, we should ask you a few questions',
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomFilledButton(
            text: 'Start Application',
            onPressed: () {
              context.read<AdoptionBloc>().add(NextStep());
            },
            heightFactor: 0.06,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
