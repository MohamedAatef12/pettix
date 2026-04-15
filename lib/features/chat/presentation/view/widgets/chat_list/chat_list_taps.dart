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

class ChatListTaps extends StatefulWidget {
  const ChatListTaps({super.key});

  @override
  State<ChatListTaps> createState() => _ChatListTapsState();
}

class _ChatListTapsState extends State<ChatListTaps>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAllChatsSelected = _tabController.index == 0;
    final isGroupsSelected = _tabController.index == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Custom Tabs Row
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _tabController.animateTo(0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isAllChatsSelected
                        ? AppColors.current.blueGray
                        : AppColors.current.lightGray,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isAllChatsSelected
                          ? AppColors.current.primary
                          : Colors.transparent,

                    )
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Available',
                    style: TextStyle(
                      color: isAllChatsSelected
                          ? AppColors.current.primary
                          : AppColors.current.lightText,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _tabController.animateTo(1),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration:  BoxDecoration(
                      color: isAllChatsSelected
                          ? AppColors.current.lightGray
                          : AppColors.current.blueGray,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isAllChatsSelected
                            ? AppColors.current.transparent
                            : AppColors.current.primary

                      )
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Archived',
                    style: TextStyle(
                      color: isGroupsSelected
                          ? AppColors.current.primary
                          : AppColors.current.lightText,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        Expanded(
          child: BlocBuilder<ChatListBloc, ChatListState>(
            builder: (context, state) {
              if (state is ChatListLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ChatListError) {
                return Center(child: Text(state.message, style: TextStyle(color: Colors.red)));
              } else if (state is ChatListSuccess) {
                final allConversations = state.conversations;
                // Currently returning same list for both tabs just to render it. You can filter them based on groups vs individuals if available.
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildConversationList(allConversations, state.currentUserId),
                    _buildConversationList(allConversations.where((c) => c.type == 'group').toList(), state.currentUserId),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConversationList(List<ConversationEntity> conversations, int? currentUserId) {
    if (conversations.isEmpty) {
      return Center(child: Text('No conversations found', style: AppTextStyles.description));
    }
    return ListView.builder(
      itemCount: conversations.length,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        // Filter out current user to find the other participant
        final otherMember = conversation.members.where((m) => m.user.id != currentUserId).firstOrNull ?? 
                          (conversation.members.isNotEmpty ? conversation.members.first : null);
        final displayMember = otherMember?.user;
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to ChatPage with conversation details
                // You can update this based on your routing params. Assumed passing conversation id.
                context.pushNamed(
                  AppRouteNames.chat,
                  pathParameters: {'index': conversation.id.toString()},
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                decoration: BoxDecoration(
                  color: AppColors.current.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.current.blueGray,
                  ),
                ),
                child: Padding(
                  padding: PaddingConstants.small,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35.r,
                        backgroundColor: AppColors.current.transparent,
                        // Fallback image if avatar is missing
                        backgroundImage: displayMember?.avatar != null && displayMember!.avatar.isNotEmpty 
                            ? NetworkImage(displayMember.avatar) as ImageProvider
                            : const AssetImage('assets/images/profile_photo.png'),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayMember?.displayName ?? 'Conversation ${conversation.id}',
                              style: AppTextStyles.appbar,
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    conversation.lastMessage?.content ?? 'No messages yet...',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                if (conversation.lastMessage != null) 
                                Text(
                                  _formatDate(conversation.lastMessage!.sentAt),
                                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    // Basic formatting, e.g., 2:30 PM
    return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

}
