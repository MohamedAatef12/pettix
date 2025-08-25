import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pettix/features/on_boarding/presentation/bloc/on_boarding_bloc.dart';
import 'package:pettix/features/on_boarding/presentation/view/widgets/on_boarding_body.dart';


class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnBoardingBloc(),
      child: Scaffold(
        body: OnBoardingBody(),
      ),
    );
  }
}

