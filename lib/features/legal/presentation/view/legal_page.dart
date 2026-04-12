import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.current.white,
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 3)),
                      ],
                    ),
                    child: Column(
                      children: [
                        _LegalTile(
                          icon: Icons.info_outline_rounded,
                          iconColor: AppColors.current.primary,
                          title: 'About Pettix',
                          subtitle: 'Our mission, features, and contact info',
                          onTap: () => context.push(AppRoutes.aboutPettix),
                          isFirst: true,
                        ),
                        _Divider(),
                        _LegalTile(
                          icon: Icons.shield_outlined,
                          iconColor: const Color(0xFF10B981),
                          title: 'Privacy Policy',
                          subtitle: 'How we collect and protect your data',
                          onTap: () => context.push(AppRoutes.privacyPolicy),
                        ),
                        _Divider(),
                        _LegalTile(
                          icon: Icons.gavel_rounded,
                          iconColor: const Color(0xFF7A6FD8),
                          title: 'Terms & Conditions',
                          subtitle: 'Rules and guidelines for using Pettix',
                          onTap: () => context.push(AppRoutes.termsConditions),
                        ),
                        _Divider(),
                        _LegalTile(
                          icon: Icons.assignment_return_outlined,
                          iconColor: const Color(0xFFF97316),
                          title: 'Refund Policy',
                          subtitle: 'Returns, refunds, and shipping costs',
                          onTap: () => context.push(AppRoutes.refundPolicy),
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Center(
                    child: Column(
                      children: [
                        Image.asset('assets/images/horizontal_logo.png', height: 22.h),
                        SizedBox(height: 8.h),
                        Text(
                          'Version 1.0.0',
                          style: AppTextStyles.smallDescription.copyWith(
                            fontSize: 12.sp, color: AppColors.current.midGray,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '© ${DateTime.now().year} Pettix. All rights reserved.',
                          style: AppTextStyles.smallDescription.copyWith(
                            fontSize: 11.sp, color: AppColors.current.lightGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.current.primary, AppColors.current.primary.withAlpha(210)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 20.h),
          child: Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20.w),
              ),
              Expanded(
                child: Text(
                  'Legal',
                  style: AppTextStyles.appbar.copyWith(
                    color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.balance_rounded, color: Colors.white70, size: 26.w),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegalTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _LegalTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(isFirst ? 18.r : 0),
        topRight: Radius.circular(isFirst ? 18.r : 0),
        bottomLeft: Radius.circular(isLast ? 18.r : 0),
        bottomRight: Radius.circular(isLast ? 18.r : 0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Icon(icon, color: iconColor, size: 20.w),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTextStyles.bold.copyWith(fontSize: 14.sp, color: AppColors.current.text)),
                    SizedBox(height: 2.h),
                    Text(subtitle,
                        style: AppTextStyles.smallDescription.copyWith(
                            fontSize: 11.sp, color: AppColors.current.midGray)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.current.lightGray, size: 20.w),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, color: AppColors.current.lightBlue, indent: 70.w);
}
