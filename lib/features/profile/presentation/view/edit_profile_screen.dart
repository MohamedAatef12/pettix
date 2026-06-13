import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_event.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_state.dart';
import 'package:pettix/features/profile/presentation/widgets/edit_profile_body.dart';
import 'package:pettix/core/themes/app_colors.dart';
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProfileBloc>();
    // If profile is already in state (navigated from profile screen), init form now.
    // Otherwise the BlocListener below will fire once the fresh fetch completes.
    if (bloc.state.profile != null) {
      bloc.add(InitEditFormEvent());
    }
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status && curr.status == ProfileStatus.loaded,
      listener: (context, state) {
        context.read<ProfileBloc>().add(InitEditFormEvent());
      },
      child: Scaffold(
        backgroundColor: AppColors.current.lightBlue,
        body: const SafeArea(child: EditProfileBody()),
      ),
    );
  }
}
