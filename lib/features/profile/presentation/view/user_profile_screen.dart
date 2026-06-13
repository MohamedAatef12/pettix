import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_bloc.dart';
import 'package:pettix/features/my_pets/presentation/bloc/my_pets_event.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_event.dart';
import 'package:pettix/features/profile/presentation/widgets/profile_body.dart';

class UserProfileScreen extends StatelessWidget {
  final int contactId;
  const UserProfileScreen({super.key, required this.contactId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  DI.find<ProfileBloc>()
                    ..add(FetchProfileEvent(userId: contactId)),
        ),
        BlocProvider(
          create:
              (_) =>
                  DI.find<MyPetsBloc>()
                    ..add(FetchUserPetsEvent(userId: contactId))
                    ..add(const FetchPetOptionsEvent()),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.current.lightBlue,
        body: ProfileBody(isCurrentUser: false, userId: contactId),
      ),
    );
  }
}
