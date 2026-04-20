import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat/profile_card.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_event.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_state.dart';

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pettix/features/chat/domain/entity/message_entity.dart';
import 'package:pettix/core/shimmers/chat_body_shimmer.dart';

class ChatConversation extends StatefulWidget {
  final int userIndex;
  const ChatConversation({super.key, required this.userIndex});

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50) {
      final state = context.read<ChatBloc>().state;
      if (state.hasMore && state.status != ChatStatus.paginating && state.status != ChatStatus.loading) {
        if (state.conversationId != null) {
          context.read<ChatBloc>().add(GetMessagesEvent(state.conversationId!));
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.status == ChatStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == ChatStatus.error) {
          return Center(child: Text(state.errorMessage, style: const TextStyle(color: Colors.red)));
        }

        final messages = state.messages;

        final isPaginating = state.status == ChatStatus.paginating;

        return ListView.builder(
          controller: _scrollController,
          // slots: messages + optional spinner + profile card (always last = always top)
          itemCount: messages.length + (isPaginating ? 1 : 0) + 1,
          padding: EdgeInsets.only(bottom: 16.h),
          reverse: true,
          itemBuilder: (context, index) {
            final totalSlots = messages.length + (isPaginating ? 1 : 0);

            // Profile card is always the very last slot → stays pinned at the top
            if (index == totalSlots) {
              final otherMember = state.conversation?.members
                      .where((m) => m.user.id != state.currentUserId)
                      .firstOrNull ??
                  (state.conversation?.members.isNotEmpty == true
                      ? state.conversation?.members.first
                      : null);
              return Column(
                children: [
                  ProfileCard(
                    index: widget.userIndex,
                    name: otherMember?.user.displayName,
                    avatarUrl: otherMember?.user.avatar,
                  ),
                  SizedBox(height: 10.h),
                ],
              );
            }

            // Pagination spinner sits just above the oldest message, below the card
            if (isPaginating && index == messages.length) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final msg = messages[index];
            final isMe = msg.senderId == state.currentUserId;

            return ChatBubble(
              text: msg.content,
              isMe: isMe,
              isSending: msg.isSending,
              imageUrl: msg.imageUrl,
            );
          },
        );
      },
    );
  }
}


class ChatBubble extends StatelessWidget {
  final String text;
  final String? imageUrl;
  final bool isMe;
  final bool isSending;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    this.isSending = false,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
            padding: imageUrl != null ? EdgeInsets.all(4.r) : EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            constraints: BoxConstraints(maxWidth: 260.w),
            decoration: BoxDecoration(
              color: isMe
                  ? AppColors.current.primary
                  : AppColors.current.blueGray.withValues(alpha: 0.4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                topRight: Radius.circular(14.r),
                bottomLeft: isMe ? Radius.circular(14.r) : Radius.circular(0),
                bottomRight: isMe ? Radius.circular(0) : Radius.circular(14.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imageUrl != null)
                  GestureDetector(
                    onTap: () => _openImagePreview(context, imageUrl!),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: _buildImage(imageUrl!),
                    ),
                  ),
                if (text.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: imageUrl != null ? 8.w : 4.w,
                      vertical: imageUrl != null ? 6.h : 2.h,
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isMe ? Colors.white : AppColors.current.text,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isMe && isSending) SizedBox(width: 8.w),
          if (isMe && isSending)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: SizedBox(
                width: 12.w,
                height: 12.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.current.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      debugPrint('💬 ChatBubble loading image: $path');
      return CachedNetworkImage(
        imageUrl: path,
        cacheKey: path,
        httpHeaders: const {
          'ngrok-skip-browser-warning': 'true',
          'User-Agent': 'Mozilla/5.0',
        },
        width: 200.w,
        height: 150.h,
        fit: BoxFit.cover,
        errorWidget: (_, __, error) {
          debugPrint('❌ Chat image load error: $error');
          return Container(
            width: 200.w,
            height: 150.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Center(
              child: Icon(Icons.broken_image_outlined, size: 40, color: Colors.grey),
            ),
          );
        },
      );
    } else {
      // Local path for optimistic UI
      return Image.file(
        File(path),
        width: 200.w,
        height: 150.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 200.w,
          height: 150.h,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: const Center(
            child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
          ),
        ),
      );
    }
  }

  void _openImagePreview(BuildContext context, String path) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black.withValues(alpha: 0.92),
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.88, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
      pageBuilder: (dialogContext, _, __) {
        return GestureDetector(
          onTap: () => Navigator.of(dialogContext).pop(),
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {}, // Prevent dismissal when tapping the image
                    child: Hero(
                      tag: 'chat_image_$path',
                      child: InteractiveViewer(
                        minScale: 0.8,
                        maxScale: 4.0,
                        child: _buildPreviewImage(path),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: GestureDetector(
                    onTap: () => Navigator.of(dialogContext).pop(),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 24),
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

  Widget _buildPreviewImage(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return CachedNetworkImage(
        imageUrl: path,
        cacheKey: path,
        httpHeaders: const {
          'ngrok-skip-browser-warning': 'true',
          'User-Agent': 'Mozilla/5.0',
        },
        fit: BoxFit.contain,
        placeholder: (_, __) => const SizedBox(
          width: 60,
          height: 60,
          child: Center(child: CircularProgressIndicator(color: Colors.white70)),
        ),
        errorWidget: (_, __, ___) => const Icon(
          Icons.broken_image_outlined,
          size: 80,
          color: Colors.white54,
        ),
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.image_not_supported,
          size: 80,
          color: Colors.white54,
        ),
      );
    }
  }
}
