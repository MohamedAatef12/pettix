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

class ChatListTaps extends StatelessWidget {
  const ChatListTaps({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatListBloc, ChatListState>(
      builder: (context, state) {
        if (state is ChatListLoading) {
          return const ChatListShimmer();
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
          final conversations = state.conversations;
          if (conversations.isEmpty) {
            return Center(
              child: Text(
                'No conversations found',
                style: AppTextStyles.description,
              ),
            );
          }
          return ListView.builder(
            itemCount: conversations.length,
            padding: EdgeInsets.symmetric(vertical: 10.h),
            itemBuilder: (context, index) {
              return _ConversationCard(
                conversation: conversations[index],
                currentUserId: state.currentUserId,
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _ConversationCard extends StatelessWidget {
  final ConversationEntity conversation;
  final int? currentUserId;

  const _ConversationCard({
    required this.conversation,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    // Filter out current user to find the other participant
    final otherMember = conversation.members.where((m) => m.user.id != currentUserId).firstOrNull ??
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
              // Avatar with Hero animation and premium ring
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
                  child: CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.current.lightGray,
                    backgroundImage: displayMember?.avatar != null && displayMember!.avatar.isNotEmpty
                        ? NetworkImage(displayMember.avatar) as ImageProvider
                        : const AssetImage('assets/images/profile_photo.png'),
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
                            displayMember?.displayName ?? 'Conversation ${conversation.id}',
                            style: AppTextStyles.bold.copyWith(
                              color: _isUnread(conversation, currentUserId) 
                                  ? AppColors.current.primary 
                                  : AppColors.current.text,
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
                              fontWeight: _isUnread(conversation, currentUserId) 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                              color: _isUnread(conversation, currentUserId) 
                                  ? AppColors.current.primary 
                                  : AppColors.current.gray,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.lastMessage?.content ?? 'No messages yet...',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: _isUnread(conversation, currentUserId) 
                                  ? FontWeight.w500 
                                  : FontWeight.normal,
                              color: _isUnread(conversation, currentUserId) 
                                  ? AppColors.current.text.withValues(alpha: 0.8)
                                  : AppColors.current.lightText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_isUnread(conversation, currentUserId))
                          Container(
                            width: 10.r,
                            height: 10.r,
                            margin: EdgeInsets.only(left: 8.w),
                            decoration: BoxDecoration(
                              color: AppColors.current.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.current.primary.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                      ],
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

  bool _isUnread(ConversationEntity conversation, int? currentUserId) {
    if (conversation.lastMessage == null || currentUserId == null) return false;
    
    // If I sent the last message, don't show an unread dot
    if (conversation.lastMessage!.senderId == currentUserId) return false;
    
    // Find my member record to check lastReadMessageId
    final myMember = conversation.members.where((m) => m.userId == currentUserId).firstOrNull;
    if (myMember == null) return false;

    // Show dot if the last message ID is greater than what I've read
    return conversation.lastMessage!.id > (myMember.lastReadMessageId ?? 0);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    if (difference.inDays < 7) {
      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[date.weekday - 1];
    }
    return '${date.day}/${date.month}';
  }
}
