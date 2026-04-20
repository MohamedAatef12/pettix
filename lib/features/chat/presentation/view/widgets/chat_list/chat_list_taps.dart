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
                      child: const _UpdatingBanner(),
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
class _UpdatingBanner extends StatefulWidget {
  const _UpdatingBanner();

  @override
  State<_UpdatingBanner> createState() => _UpdatingBannerState();
}

class _UpdatingBannerState extends State<_UpdatingBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dot1;
  late Animation<double> _dot2;
  late Animation<double> _dot3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _dot1 = _buildDotAnim(0.0);
    _dot2 = _buildDotAnim(0.2);
    _dot3 = _buildDotAnim(0.4);
  }

  Animation<double> _buildDotAnim(double begin) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.4, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.4), weight: 30),
      TweenSequenceItem(tween: ConstantTween(0.4), weight: 40),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(begin, begin + 0.6, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.current.primary,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.current.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Updating',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(width: 6.w),
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Dot(opacity: _dot1.value),
                SizedBox(width: 3.w),
                _Dot(opacity: _dot2.value),
                SizedBox(width: 3.w),
                _Dot(opacity: _dot3.value),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final double opacity;
  const _Dot({required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 5.r,
        height: 5.r,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
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
                  child: CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.current.lightGray,
                    backgroundImage: displayMember?.avatar != null &&
                            displayMember!.avatar.isNotEmpty
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
