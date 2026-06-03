import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';

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
                        BoxShadow(
                          color: Colors.black.withAlpha(8),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _LegalTile(
                          icon: Icons.info_outline_rounded,
                          iconColor: AppColors.current.primary,
                          title: AppText.aboutPettix,
                          subtitle: AppText.aboutPettixSubtitle,
                          onTap: () => context.push(AppRoutes.aboutPettix),
                          isFirst: true,
                        ),
                        _Divider(),
                        _LegalTile(
                          icon: Icons.shield_outlined,
                          iconColor: const Color(0xFF10B981),
                          title: AppText.privacyPolicyTitle,
                          subtitle: AppText.privacyPolicySubtitle,
                          onTap: () => context.push(AppRoutes.privacyPolicy),
                        ),
                        _Divider(),
                        _LegalTile(
                          icon: Icons.gavel_rounded,
                          iconColor: const Color(0xFF7A6FD8),
                          title: AppText.termsConditions,
                          subtitle: AppText.termsConditionsSubtitle,
                          onTap: () => context.push(AppRoutes.termsConditions),
                        ),
                        _Divider(),
                        _LegalTile(
                          icon: Icons.assignment_return_outlined,
                          iconColor: const Color(0xFFF97316),
                          title: AppText.refundPolicy,
                          subtitle: AppText.refundPolicySubtitle,
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/logo1.png',
                              height: 25.h,
                              width: 25.w,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              AppText.appName,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.current.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          AppText.versionNumber('1.0.0'),
                          style: AppTextStyles.smallDescription.copyWith(
                            fontSize: 12.sp,
                            color: AppColors.current.midGray,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          AppText.copyright(DateTime.now().year.toString()),
                          style: AppTextStyles.smallDescription.copyWith(
                            fontSize: 11.sp,
                            color: AppColors.current.lightGray,
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
        color: AppColors.current.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 20.h),
          child: Row(
            children: [
              AppTopBarBackButton(onPressed: () => context.pop()),
              Expanded(
                child: Text(
                  AppText.legal,
                  style: AppTextStyles.appbar.copyWith(
                    color: AppColors.current.text,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.balance_rounded,
                color: AppColors.current.midGray,
                size: 26.w,
              ),
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
                    Text(
                      title,
                      style: AppTextStyles.bold.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.current.text,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.smallDescription.copyWith(
                        fontSize: 11.sp,
                        color: AppColors.current.midGray,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.current.lightGray,
                size: 20.w,
              ),
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
