import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/chat/presentation/view/widgets/chat/profile_card.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_event.dart';
import 'package:pettix/features/chat/presentation/bloc/chat_state.dart';
import 'package:pettix/features/chat/presentation/view/widgets/updating_banner.dart';
import 'package:pettix/core/widgets/app_cached_image.dart';

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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      final state = context.read<ChatBloc>().state;
      if (state.hasMore &&
          state.status != ChatStatus.paginating &&
          state.status != ChatStatus.loading) {
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
        if (state.status == ChatStatus.loading && state.messages.isEmpty) {
          return const Center(child: UpdatingBanner());
        } else if (state.status == ChatStatus.error && state.messages.isEmpty) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final messages = state.messages;
        final isPaginating = state.status == ChatStatus.paginating;

        return Stack(
          children: [
            ListView.builder(
              controller: _scrollController,
              // slots: messages + optional spinner + profile card (always last = always top)
              itemCount: messages.length + (isPaginating ? 1 : 0) + 1,
              padding: EdgeInsets.only(bottom: 16.h),
              reverse: true,
              itemBuilder: (context, index) {
                final totalSlots = messages.length + (isPaginating ? 1 : 0);

                // Profile card is always the very last slot → stays pinned at the top
                if (index == totalSlots) {
                  final otherMember =
                      state.conversation?.members
                          .where((m) => m.user.id != state.currentUserId)
                          .firstOrNull ??
                      (state.conversation?.members.isNotEmpty == true
                          ? state.conversation?.members.first
                          : null);
                  return Column(
                    children: [
                      ProfileCard(
                        index: otherMember?.user.id ?? widget.userIndex,
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

                final conversationId = state.conversationId!;
                return ChatBubble(
                  text: msg.content,
                  isMe: isMe,
                  isSending: msg.isSending,
                  isFailed: msg.isFailed,
                  imageUrl: msg.imageUrl,
                  onResend: msg.isFailed
                      ? () => context.read<ChatBloc>().add(ResendMessageEvent(
                            failedMessageId: msg.id,
                            conversationId: conversationId,
                            content: msg.content,
                            imagePath: msg.imageUrl,
                          ))
                      : null,
                );
              },
            ),
            if (state.status == ChatStatus.loading)
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: const UpdatingBanner(),
                ),
              ),
          ],
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
  final bool isFailed;
  final VoidCallback? onResend;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isMe,
    this.isSending = false,
    this.isFailed = false,
    this.imageUrl,
    this.onResend,
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
            padding:
                imageUrl != null
                    ? EdgeInsets.all(4.r)
                    : EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            constraints:BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.55),
            decoration: BoxDecoration(
              color:
                  isMe
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
                      child: AppCachedImage(
                        imageUrl: imageUrl!,
                        width: 200.w,
                        height: 150.h,
                      ),
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
                if (isMe) ...[                  
                  if (isFailed) ...[                    
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.h, right: 2.w, bottom: 2.h),
                        child: Icon(
                          Icons.error_outline,
                          size: 14.r,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ] else if (isSending) ...[                    
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.h, right: 2.w, bottom: 2.h),
                        child: Icon(
                          Icons.access_time_rounded,
                          size: 14.r,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ] else ...[                    
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.h, right: 2.w, bottom: 2.h),
                        child: Icon(
                          Icons.done_all,
                          size: 14.r,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
          // Resend button shown outside the bubble when failed
          if (isMe && isFailed && onResend != null)
            GestureDetector(
              onTap: onResend,
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.h, right: 4.w),
                child: Icon(
                  Icons.refresh_rounded,
                  size: 18.r,
                  color: Colors.redAccent,
                ),
              ),
            ),
    ]
      ),
    );
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
                        child: AppCachedImage(
                          imageUrl: path,
                          fit: BoxFit.contain,
                        ),
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
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
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
