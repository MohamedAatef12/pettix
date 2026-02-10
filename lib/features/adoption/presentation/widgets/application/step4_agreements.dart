import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/adoption_bloc.dart';
import '../../bloc/adoption_event.dart';
import '../../bloc/adoption_state.dart';

class Step4Agreements extends StatelessWidget {
  const Step4Agreements({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: BlocBuilder<AdoptionBloc, AdoptionState>(
        builder: (context, state) {
          final bloc = context.read<AdoptionBloc>();
          return ListView(
            children: [
              const Text(
                "I Understand that:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "• Pettix is a platform to connect pet lovers, adopters, clinics, and stores, but it does not replace professional veterinary advice.",
                  style: TextStyle(height: 1.5, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "• Any shared content in the community section is the responsibility of the user who posts it.",
                  style: TextStyle(height: 1.5, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "I Agree to:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "• Use Pettix responsibly and respectfully, without harmful or inappropriate behavior.",
                  style: TextStyle(height: 1.5, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "• Provide accurate and truthful information when creating my profile or posting.",
                  style: TextStyle(height: 1.5, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: const Color(0xff5379B2),
                      checkColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xffD0D5DD),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      value: state.agreed,
                      onChanged: (v) => bloc.add(ToggleAgreement(v!)),
                      title: const Text(
                        "I have read and understood the points above.",
                        style: TextStyle(color: Color(0xff475467)),
                      ),
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                    ),
                    child: CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: const Color(0xff5379B2),
                      checkColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xffD0D5DD),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      value: state.termsAccepted,
                      onChanged: (v) => bloc.add(ToggleTermsAcceptance(v!)),
                      title: const Text(
                        "I agree to all the terms and conditions.",
                        style: TextStyle(color: Color(0xff475467)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
