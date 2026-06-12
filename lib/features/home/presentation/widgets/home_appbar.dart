import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_state.dart';
import 'package:pettix/core/widgets/app_profile_image.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DI.find<ICacheManager>().getUserData();
    return Padding(
      padding: PaddingConstants.medium,
      child: Row(
        children: [
          GestureDetector(
            onTap:
                () =>
                    context
                        .findRootAncestorStateOfType<ScaffoldState>()
                        ?.openDrawer(),
            child: AppProfileImage(
              imageUrl: user?.avatar ?? user?.image,
              name: user?.userName,
              radius: 27.r,
            ),
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: 120.w,
            child: Text(
              user?.userName ?? AppText.userFallback,
              style: AppTextStyles.bold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              context.push('/notifications');
            },
            child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AppIconButton(
                      token: AppIconToken.notification,
                      size: 40.r,
                      iconSize: 20.r,
                      color: AppColors.current.text,
                      backgroundColor: AppColors.current.white,
                    ),
                    if (state.totalUnreadCount > 0)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 10.w,
                            minHeight: 10.h,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
