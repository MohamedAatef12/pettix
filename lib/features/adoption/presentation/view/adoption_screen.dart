import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_bloc.dart';
import 'package:pettix/features/adoption/presentation/bloc/adoption_browse_event.dart';
import 'package:pettix/features/adoption/presentation/widgets/adoption/adoption_body.dart';

class AdoptionScreen extends StatelessWidget {
  const AdoptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DI.find<AdoptionBrowseBloc>()
        ..add(const InitAdoptionBrowseEvent()),
      child: const Scaffold(
        backgroundColor: Color(0xFFF5F7FF),
        body: AdoptionBody(),
      ),
    );
  }
}
