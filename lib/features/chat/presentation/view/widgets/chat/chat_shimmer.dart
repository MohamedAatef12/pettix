import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';

class ChatShimmer extends StatelessWidget {
  const ChatShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      itemBuilder: (context, index) {
        final isLeft = index % 2 == 0;
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Row(
            mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (isLeft) ...[
                AppShimmer.circular(radius: 16.r),
                SizedBox(width: 8.w),
              ],
              AppShimmer(
                width: 150.w + (index % 3) * 20.w,
                height: 40.h,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ],
          ),
        );
      },
    );
  }
}
