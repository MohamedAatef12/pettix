import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/enums/app_enums.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_event.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_state.dart';
import 'package:pettix/features/notification/presentation/view/widgets/notification_card.dart';
import 'package:pettix/features/notification/presentation/view/widgets/notification_shimmer.dart';
import 'package:pettix/features/notification/presentation/view/widgets/empty_notifications.dart';

class AllNotifications extends StatefulWidget {
  const AllNotifications({super.key});

  @override
  State<AllNotifications> createState() => _AllNotificationsState();
}

class _AllNotificationsState extends State<AllNotifications> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<NotificationBloc>().state;
      if (state.hasMore && !state.isPaginating) {
        final currentType = NotificationType.values[state.currentIndex].value;
        final nextPage = (state.notifications.length / 10).floor() + 1;
        
        context.read<NotificationBloc>().add(GetNotificationsEvent(
          notificationTypeId: currentType,
          pageIndex: nextPage,
        ));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state.status == NotificationStatus.loading) {
          return const NotificationShimmer();
        }
        if (state.status == NotificationStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48.sp, color: AppColors.current.red),
                SizedBox(height: 16.h),
                Text(state.errorMessage, style: AppTextStyles.description),
              ],
            ),
          );
        }
        if (state.notifications.isEmpty) {
          return const Center(
            child: EmptyNotifications(),
          );
        }
        return ListView.builder(
            controller: _scrollController,
            itemCount: state.notifications.length + (state.isPaginating ? 1 : 0),
            padding: EdgeInsets.only(bottom: 20.h),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (index >= state.notifications.length) {
                return const NotificationItemShimmer();
              }
              final notification = state.notifications[index];
              return NotificationCard(
                color: AppColors.current.white,
                notification: notification,
              );
            });
      },
    );
  }
}
