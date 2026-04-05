import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_event.dart';
import 'package:pettix/features/profile/presentation/bloc/profile_state.dart';

class AvatarPicker extends StatelessWidget {
  final String? currentAvatarUrl;
  const AvatarPicker({super.key, this.currentAvatarUrl});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (prev, curr) => prev.pickedAvatar != curr.pickedAvatar,
      builder: (context, state) {
        final ImageProvider image = state.pickedAvatar != null
            ? FileImage(state.pickedAvatar!)
            : currentAvatarUrl != null
                ? NetworkImage(currentAvatarUrl!) as ImageProvider
                : const AssetImage('assets/images/no_user.png');

        return Center(
          child: GestureDetector(
            onTap: () => context.read<ProfileBloc>().add(PickAvatarEvent()),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.current.gold,
                        AppColors.current.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: CircleAvatar(
                      radius: 52.r,
                      backgroundColor: AppColors.current.lightGray,
                      backgroundImage: image,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4.h,
                  right: 4.w,
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: AppColors.current.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.w),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.current.primary.withAlpha(80),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 14.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
