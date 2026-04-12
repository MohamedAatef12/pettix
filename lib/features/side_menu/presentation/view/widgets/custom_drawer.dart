import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/features/auth/data/models/user_model.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DI.find<ICacheManager>().getUserData();
    final screenWidth = MediaQuery.of(context).size.width;

    return Drawer(
      width: screenWidth * 0.82,
      backgroundColor: AppColors.current.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.r),
          bottomRight: Radius.circular(10.r),
        ),
      ),
      child: Column(
        children: [
          _DrawerHeader(user: user),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  _Section(AppText.myProfile),
                  _Tile(
                    icon: Icons.person_outline_rounded,
                    label: AppText.viewProfile,
                    color: AppColors.current.primary,
                    onTap: () => context.push(AppRoutes.profile),
                  ),
                  _Tile(
                    icon: Icons.edit_rounded,
                    label: AppText.editProfile,
                    color: const Color(0xFF7A6FD8),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push(AppRoutes.editProfile);
                    },
                  ),
                  _Section(AppText.activity),
                  _Tile(
                    icon: Icons.article_rounded,
                    label: AppText.myPosts,
                    color: const Color(0xFF3AAFA9),
                    onTap: () {},
                  ),
                  _TileSvg(
                    path: 'assets/icons/save_post.svg',
                    label: AppText.savedPosts,
                    color: const Color(0xFFE8A838),
                    onTap: () {},
                  ),
                  _Section(AppText.adoptionPets),
                  _Tile(
                    icon: Icons.pets_rounded,
                    label: AppText.adoptionHistory,
                    color: AppColors.current.gold,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push(AppRoutes.adoptionHistory);
                    },
                  ),
                  _Section(AppText.storeOrders),
                  _Tile(
                    icon: Icons.inventory_2_rounded,
                    label: AppText.myOrders,
                    color: const Color(0xFF5EA8DF),
                    onTap: () {},
                  ),
                  _Tile(
                    icon: Icons.location_on_rounded,
                    label: AppText.myAddresses,
                    color: const Color(0xFFEA6060),
                    onTap: () {},
                  ),
                  _Tile(
                    icon: Icons.credit_card_rounded,
                    label: AppText.paymentMethods,
                    color: const Color(0xFF56C590),
                    onTap: () {},
                  ),
                  _TileSvg(
                    path: 'assets/icons/refund.svg',
                    label: AppText.refundsReturns,
                    color: AppColors.current.midGray,
                    onTap: () {},
                  ),
                  _Section(AppText.emergency),
                  _Tile(
                    icon: Icons.emergency_rounded,
                    label: AppText.emergencyReports,
                    color: AppColors.current.red,
                    onTap: () {},
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 4.h),
                    child: Divider(
                      color: AppColors.current.lightGray,
                      thickness: 1,
                    ),
                  ),
                  _TilePng(
                    path: 'assets/icons/settings.png',
                    label: AppText.settings,
                    color: AppColors.current.gray,
                    onTap: () {},
                  ),
                  _Tile(
                    icon: Icons.help_outline_rounded,
                    label: AppText.helpSupport,
                    color: AppColors.current.primary,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push(AppRoutes.helpSupport);
                    },
                  ),
                  _TileSvg(
                    path: 'assets/icons/terms.svg',
                    label: AppText.legal,
                    color: AppColors.current.gray,
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push(AppRoutes.legal);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 4.h),
                    child: Divider(
                      color: AppColors.current.lightGray,
                      thickness: 1,
                    ),
                  ),
                  const _LogoutTile(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _DrawerHeader extends StatelessWidget {
  final UserModel? user;
  const _DrawerHeader({this.user});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.current.primary,
            AppColors.current.primary.withAlpha(210),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(20.w, topPad + 20.h, 20.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(url: user?.avatar),
              SizedBox(width: 14.w),
              Expanded(child: _UserInfo(user: user)),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.white60,
                  size: 20.w,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RoleBadge(),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      AppText.switchRole,
                      style: AppTextStyles.smallDescription.copyWith(
                        color: Colors.white70,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.swap_horiz_rounded,
                      color: Colors.white70,
                      size: 14.w,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? url;
  const _Avatar({this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 28.r,
        backgroundColor: AppColors.current.lightGray,
        backgroundImage:
            url != null
                ? NetworkImage("${Constants.baseUrl}/${url!}")
                : const AssetImage('assets/images/no_user.png')
                    as ImageProvider,
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  final UserModel? user;
  const _UserInfo({this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                user?.userName ?? AppText.userName,
                style: AppTextStyles.bold.copyWith(
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.verified_rounded, color: Colors.white70, size: 14.w),
          ],
        ),
        SizedBox(height: 3.h),
        Text(
          user?.email ?? '',
          style: AppTextStyles.smallDescription.copyWith(
            color: Colors.white60,
            fontSize: 11.sp,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        if (user?.phone != null) ...[
          SizedBox(height: 1.h),
          Text(
            user!.phone!,
            style: AppTextStyles.smallDescription.copyWith(
              color: Colors.white60,
              fontSize: 11.sp,
            ),
          ),
        ],
      ],
    );
  }
}

class _RoleBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(40),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withAlpha(60), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.pets_rounded, color: Colors.white70, size: 11.w),
          SizedBox(width: 4.w),
          Text(
            AppText.petLover,
            style: AppTextStyles.smallDescription.copyWith(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final String title;
  const _Section(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 4.h),
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

// ─── Tile variants ────────────────────────────────────────────────────────────

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => _TileBase(
    iconWidget: Icon(icon, color: color, size: 18.w),
    iconBg: color.withAlpha(26),
    label: label,
    onTap: onTap,
  );
}

class _TileSvg extends StatelessWidget {
  final String path;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _TileSvg({
    required this.path,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => _TileBase(
    iconWidget: SvgPicture.asset(
      path,
      width: 40.w,
      height: 40.w,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    ),
    iconBg: color.withAlpha(26),
    label: label,
    onTap: onTap,
  );
}

class _TilePng extends StatelessWidget {
  final String path;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _TilePng({
    required this.path,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => _TileBase(
    iconWidget: Image.asset(path, width: 18.w, height: 18.w, color: color),
    iconBg: color.withAlpha(26),
    label: label,
    onTap: onTap,
  );
}

class _TileBase extends StatelessWidget {
  final Widget iconWidget;
  final Color iconBg;
  final String label;
  final VoidCallback onTap;

  const _TileBase({
    required this.iconWidget,
    required this.iconBg,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(child: iconWidget),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.description.copyWith(
                  color: AppColors.current.text,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.current.midGray,
              size: 18.w,
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutTile extends StatelessWidget {
  const _LogoutTile();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final cache = DI.find<ICacheManager>();
        cache.logout();
        await GoogleSignIn().signOut();
        if (context.mounted) context.pushReplacement('/login');
      },
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: AppColors.current.red.withAlpha(26),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/logout_right.svg',
                  width: 18.w,
                  height: 18.w,
                  colorFilter: ColorFilter.mode(
                    AppColors.current.red,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              AppText.logout,
              style: AppTextStyles.description.copyWith(
                color: AppColors.current.red,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
