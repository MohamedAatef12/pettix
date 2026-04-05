import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_event.dart';
import 'package:pettix/features/profile/presentation/widgets/edit_profile_body.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Re-use the same ProfileBloc from parent; init controllers with current data
    context.read<ProfileBloc>().add(InitEditFormEvent());
    return const Scaffold(
      body: SafeArea(child: EditProfileBody()),
    );
  }
}
