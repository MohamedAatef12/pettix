import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';

class NotificationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NotificationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTopBar.back(
      title: AppText.notificationsText,
      backgroundColor: AppColors.current.white,
      onBack: () => Navigator.pop(context),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 4.h);
}
