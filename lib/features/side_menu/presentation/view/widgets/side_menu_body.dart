import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/features/side_menu/presentation/view/widgets/app_settings_card.dart';
import 'package:pettix/features/side_menu/presentation/view/widgets/app_terms_card.dart';
import 'package:pettix/features/side_menu/presentation/view/widgets/logout.dart';
import 'package:pettix/features/side_menu/presentation/view/widgets/profile_card.dart';

class SideMenuBody extends StatelessWidget {
  const SideMenuBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.horizontalMedium,
      child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 10.h,),
          ProfileCard(),
          SizedBox(height: 20.h,),
          AppSettingsCard(),
          SizedBox(height: 20.h,),
          AppTermsCard(),
          SizedBox(height: 20.h,),
          Logout(),
          SizedBox(height: 80.h,),
          CustomFilledButton(
            hasLeading: true,
            widthFactor: 0.6,
            leading: SvgPicture.asset('assets/icons/switch.svg',
            width: 18.w,
            height: 18.h,
            ),
            text: 'Switch to clinic',
            onPressed: () {
              // Handle delete account action
            },
            backgroundColor: AppColors.current.primary,
            textColor: AppColors.current.white,
          ),
          SizedBox(height: 20.h,),
        ]
        ),
      ),
    );
  }
}
