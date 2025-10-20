import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/side_menu/presentation/view/widgets/side_menu_app_bar.dart';
import 'package:pettix/features/side_menu/presentation/view/widgets/side_menu_body.dart';

class SideMenuPage extends StatelessWidget {
  const SideMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightGray,
      body: SafeArea(
        child: Column(
          children: [SideMenuAppBar(), SizedBox(height: 10.h), Expanded(child: SideMenuBody())],
        ),
      ),
    );
  }
}
