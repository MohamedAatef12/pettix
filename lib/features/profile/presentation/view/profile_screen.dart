import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_bloc.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_event.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_event.dart';
import 'package:pettix/features/profile/presentation/widgets/profile_body.dart';
import 'package:pettix/core/themes/app_colors.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DI.find<ProfileBloc>()..add(FetchProfileEvent()),
        ),
        BlocProvider(
          create: (_) => DI.find<MyPetsBloc>()
            ..add(const FetchUserPetsEvent())
            ..add(const FetchPetOptionsEvent()),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.current.lightBlue,
        body: const SafeArea(child: ProfileBody()),
      ),
    );
  }
}
