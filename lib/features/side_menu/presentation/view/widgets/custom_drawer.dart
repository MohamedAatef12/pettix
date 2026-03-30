import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DI.find<ICacheManager>().getUserData();

    return Drawer(
      backgroundColor: AppColors.current.white,
      surfaceTintColor: Colors.transparent, // remove Material 3 tint
      child: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20.h,
              left: 20.w,
              right: 20.w,
              bottom: 20.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.current.gold,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.r),
                // bottomLeft: Radius.circular(20.r), // Based on screenshot, seems flush to left edge, radius only on right? Actually standard to just apply to bottom edge.
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.w),
                      ),
                      child: CircleAvatar(
                        radius: 35.r,
                        backgroundImage: user?.avatar != null 
                            ? NetworkImage(user!.avatar!) 
                            : const AssetImage('assets/images/no_user.png') as ImageProvider,
                        backgroundColor: AppColors.current.lightGray,
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user?.userName ?? 'User Name',
                                style: AppTextStyles.bold.copyWith(color: Colors.white),
                              ),
                              SizedBox(width: 5.w),
                              Icon(Icons.check_circle_outline, color: Colors.white, size: 16.w),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            user?.email ?? 'email@example.com',
                            style: AppTextStyles.smallDescription.copyWith(color: Colors.white70, fontSize: 11.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            user?.phone ?? '+20 123 456 7890',
                            style: AppTextStyles.smallDescription.copyWith(color: Colors.white70, fontSize: 11.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(76), // ~0.3 opacity
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Pet Lover',
                        style: AppTextStyles.smallDescription.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Switch Role
                      },
                      child: Text(
                        'Switch Role',
                        style: AppTextStyles.smallDescription.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Menu Items List
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('My Profile'),
                  _buildDrawerItem(
                    icon: Icons.person_outline,
                    title: 'View Profile',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.edit_outlined,
                    title: 'Edit Profile',
                    onTap: () {},
                  ),
                  const Divider(height: 1),

                  _buildSectionTitle('My Activity'),
                  _buildDrawerItem(
                    icon: Icons.article_outlined,
                    title: 'My Posts',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    iconPath: 'assets/icons/save_post.svg',
                    title: 'Saved Posts',
                    onTap: () {},
                  ),
                  const Divider(height: 1),

                  _buildSectionTitle('Adoption & Pets'),
                  _buildDrawerItem(
                    icon: Icons.assignment_outlined,
                    title: 'Adoption History',
                    onTap: () {},
                  ),
                  const Divider(height: 1),

                  _buildSectionTitle('Store & orders'),
                  _buildDrawerItem(
                    icon: Icons.inventory_2_outlined,
                    title: 'My Orders',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.location_on_outlined,
                    title: 'My Addresses',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.credit_card_outlined,
                    title: 'Payment Methods',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    iconPath: 'assets/icons/refund.svg',
                    title: 'Refunds & Returns',
                    onTap: () {},
                  ),
                  const Divider(height: 1),

                  _buildSectionTitle('Emergency'),
                  _buildDrawerItem(
                    icon: Icons.error_outline,
                    title: 'My Emergency Reports',
                    onTap: () {},
                  ),
                  const Divider(height: 1),

                  SizedBox(height: 10.h),
                  _buildDrawerItem(
                    iconPath: 'assets/icons/settings.png',
                    isPng: true,
                    title: 'Settings',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    iconPath: 'assets/icons/terms.svg',
                    title: 'Legal',
                    onTap: () {},
                  ),
                  const Divider(height: 1),

                  _buildDrawerItem(
                    iconPath: 'assets/icons/logout_right.svg',
                    title: 'Logout',
                    textColor: AppColors.current.red,
                    iconColor: AppColors.current.red,
                    hideChevron: true,
                    onTap: () async {
                      final cache = DI.find<ICacheManager>();
                      cache.logout();
                      await GoogleSignIn().signOut();
                      if (context.mounted) {
                        context.pushReplacement('/login');
                      }
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h, bottom: 5.h),
      child: Text(
        title.tr(),
        style: AppTextStyles.smallDescription.copyWith(
          color: AppColors.current.midGray,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    IconData? icon,
    String? iconPath,
    bool isPng = false,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    bool hideChevron = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                color: iconColor ?? AppColors.current.gray,
                size: 20.w,
              )
            else if (iconPath != null && !isPng)
              SvgPicture.asset(
                iconPath,
                width: 20.w,
                height: 20.w,
                colorFilter: ColorFilter.mode(
                  iconColor ?? AppColors.current.gray,
                  BlendMode.srcIn,
                ),
              )
            else if (iconPath != null && isPng)
              Image.asset(
                iconPath,
                width: 20.w,
                height: 20.w,
                color: iconColor ?? AppColors.current.gray,
              ),
            SizedBox(width: 15.w),
            Expanded(
              child: Text(
                title.tr(),
                style: AppTextStyles.description.copyWith(
                  color: textColor ?? AppColors.current.text,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
            ),
            if (!hideChevron)
              Icon(
                Icons.chevron_right,
                color: AppColors.current.midGray.withAlpha(127), // ~0.5 opacity
                size: 20.w,
              ),
          ],
        ),
      ),
    );
  }
}
