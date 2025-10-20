import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

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

        // 🔹 Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // 🟢 All Chats
              ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) => Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        context.pushNamed(
                          AppRouteNames.chat,
                          pathParameters: {'index': index.toString()},
                        ); },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                      decoration: BoxDecoration(
                        color: AppColors.current.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.current.blueGray,
                        ),
                      ),
                      child:Padding(
                        padding: PaddingConstants.small,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35.r,
                              backgroundColor:AppColors.current.transparent,
                              backgroundImage: const AssetImage(
                                'assets/images/profile_photo.png',
                              ),
                            ),
                            SizedBox(width: 8.w,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('User $index',
                                  style: AppTextStyles.appbar,
                                  ),
                                  SizedBox(height: 3.h,),
                                  Row(
                                    children: [
                                      Text('Latest message...'),
                                      Spacer(),
                                      Text('2:30 PM',),
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
                    SizedBox(height: 10.h,),
                  ],
                ),
              ),

              // 🟢 Groups
              ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) => Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
                      decoration: BoxDecoration(
                        color: AppColors.current.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.current.blueGray,
                        ),
                      ),
                      child:Padding(
                        padding: PaddingConstants.small,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 35.r,
                              backgroundColor:AppColors.current.transparent,
                              backgroundImage: const AssetImage(
                                'assets/images/profile_photo.png',
                              ),
                            ),
                            SizedBox(width: 8.w,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('User $index',
                                    style: AppTextStyles.appbar,
                                  ),
                                  SizedBox(height: 3.h,),
                                  Row(
                                    children: [
                                      Text('Latest message...'),
                                      Spacer(),
                                      Text('2:30 PM',),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
