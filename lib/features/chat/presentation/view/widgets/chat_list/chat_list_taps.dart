import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_list_bloc.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_list_state.dart';
import 'package:pettix/features/chat/domain/entity/conversation_entity.dart';
import 'package:pettix/core/shimmers/chat_list_shimmer.dart';

import 'package:pettix/features/chat/presentation/view/widgets/updating_banner.dart';
import 'package:pettix/core/widgets/app_profile_image.dart';

class ChatListTaps extends StatelessWidget {
  const ChatListTaps({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
        if (state is ChatListLoading) {
          return const Center(child: UpdatingBanner());
        } else if (state is ChatListError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48.r, color: Colors.red),
                SizedBox(height: 10.h),
                Text(state.message, style: TextStyle(color: Colors.red)),
              ],
            ),
          );
        } else if (state is ChatListSuccess) {
          final conversations = state.filteredConversations;
          if (conversations.isEmpty) {
            return Center(
              child: Text(
                state.searchQuery.isEmpty
                    ? 'No conversations found'
                    : 'No results for "${state.searchQuery}"',
                style: AppTextStyles.description,
              ),
            );
          }
          return Stack(
            children: [
              ListView.builder(
                itemCount: conversations.length,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                itemBuilder: (context, index) {
                  return _ConversationCard(
                    conversation: conversations[index],
                    currentUserId: state.currentUserId,
                  );
                },
              ),
              // Animated "Updating…" banner — slides in from top when refreshing
              AnimatedSlide(
                offset: state.isRefreshing ? Offset.zero : const Offset(0, -1.5),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  opacity: state.isRefreshing ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: const UpdatingBanner(),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}

/// Animated pill banner with pulsing dots
// Removing private _UpdatingBanner classes as they are now public in updating_banner.dart

class _ConversationCard extends StatelessWidget {
  final ConversationEntity conversation;
  final int? currentUserId;

  const _ConversationCard({
    required this.conversation,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final otherMember = conversation.members
            .where((m) => m.user.id != currentUserId)
            .firstOrNull ??
        (conversation.members.isNotEmpty ? conversation.members.first : null);
    final displayMember = otherMember?.user;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            AppRouteNames.chat,
            pathParameters: {'index': conversation.id.toString()},
            extra: {
              'name': displayMember?.displayName,
              'avatar': displayMember?.avatar,
            },
          );
        },
        child: Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: AppColors.current.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.current.primary.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Hero(
                tag: 'conversation_avatar_${conversation.id}',
                child: Container(
                  padding: EdgeInsets.all(2.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.current.primary.withValues(alpha: 0.2),
                        AppColors.current.primary.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                  child: AppProfileImage(
                    imageUrl: displayMember?.avatar,
                    radius: 30.r,
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            displayMember?.displayName ??
                                'Conversation ${conversation.id}',
                            style: AppTextStyles.bold.copyWith(
                              color: AppColors.current.text,
                              fontSize: 15.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (conversation.lastMessage != null)
                          Text(
                            _formatDate(conversation.lastMessage!.sentAt),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.current.gray,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      conversation.lastMessage?.content ?? 'No messages yet...',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.current.lightText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
    if (difference.inDays < 7) {
      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[date.weekday - 1];
    }
    return '${date.day}/${date.month}';
  }
}
