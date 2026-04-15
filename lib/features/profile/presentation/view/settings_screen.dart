import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.current.text, size: 20.sp),
        ),
        title: Text(
          AppText.settings,
          style: AppTextStyles.title.copyWith(
            color: AppColors.current.text,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Account Settings'),
              SizedBox(height: 12.h),
              _SettingsGroup(
                tiles: [
                  _SettingsTile(
                    icon: Icons.notifications_none_rounded,
                    iconColor: const Color(0xFF5EA8DF),
                    title: 'Notification Settings',
                    onTap: () {
                      // Navigate to notification settings
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.location_on_outlined,
                    iconColor: AppColors.current.red,
                    title: AppText.myAddresses,
                    onTap: () {
                      // Navigate to addresses
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.credit_card_rounded,
                    iconColor: const Color(0xFF56C590),
                    title: AppText.paymentMethods,
                    onTap: () {
                      // Navigate to payment methods
                    },
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              _buildSectionHeader('App Settings'),
              SizedBox(height: 12.h),
              _SettingsGroup(
                tiles: [
                  _SettingsTile(
                    icon: Icons.color_lens_outlined,
                    iconColor: const Color(0xFFE8A838),
                    title: 'Themes',
                    trailing: Text(
                      'Light',
                      style: AppTextStyles.smallDescription.copyWith(
                        color: AppColors.current.midGray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      // Change theme
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.language_rounded,
                    iconColor: const Color(0xFF3AAFA9),
                    title: AppText.language,
                    trailing: Text(
                      context.locale.languageCode.toUpperCase(),
                      style: AppTextStyles.smallDescription.copyWith(
                        color: AppColors.current.midGray,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () => context.push(AppRoutes.selectLanguage),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.smallDescription.copyWith(
          color: AppColors.current.midGray,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsTile> tiles;
  const _SettingsGroup({required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.current.text.withAlpha(8),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: tiles.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          indent: 52.w,
          endIndent: 16.w,
          color: AppColors.current.lightGray,
        ),
        itemBuilder: (_, i) => tiles[i],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool showArrow;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.trailing,
    required this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(15),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: iconColor, size: 18.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.description.copyWith(
                  color: AppColors.current.text,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              SizedBox(width: 8.w),
            ],
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.current.midGray.withAlpha(100),
                size: 14.sp,
              ),
          ],
        ),
      ),
    );
  }
}
