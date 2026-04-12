import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      body: Column(
        children: [
          _Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How can we help you?',
                    style: AppTextStyles.bold.copyWith(
                      fontSize: 20.sp,
                      color: AppColors.current.text,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Choose a category below to get the support you need.',
                    style: AppTextStyles.smallDescription.copyWith(
                      color: AppColors.current.midGray,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 14.w,
                    mainAxisSpacing: 14.h,
                    childAspectRatio: 1.05,
                    children: [
                      _SupportCard(
                        icon: Icons.quiz_rounded,
                        iconBg: const Color(0xFFEEF2FF),
                        iconColor: const Color(0xFF5379B2),
                        title: 'FAQ',
                        subtitle: 'Answers to the most common questions',
                        onTap: () => context.push(AppRoutes.faq),
                      ),
                      _SupportCard(
                        icon: Icons.headset_mic_rounded,
                        iconBg: const Color(0xFFECFDF5),
                        iconColor: const Color(0xFF10B981),
                        title: 'Contact Support',
                        subtitle: 'Chat, email, or call our team',
                        onTap: () => context.push(AppRoutes.contactSupport),
                      ),
                      _SupportCard(
                        icon: Icons.bug_report_rounded,
                        iconBg: const Color(0xFFFFF7ED),
                        iconColor: const Color(0xFFF97316),
                        title: 'Report a Problem',
                        subtitle: 'Tell us what\'s broken or not working',
                        onTap: () => context.push(AppRoutes.reportProblem),
                      ),
                      _SupportCard(
                        icon: Icons.rate_review_rounded,
                        iconBg: const Color(0xFFFDF4FF),
                        iconColor: const Color(0xFFA855F7),
                        title: 'Send Feedback',
                        subtitle: 'Share ideas to help us improve',
                        onTap: () => context.push(AppRoutes.sendFeedback),
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),
                  _QuickHelpBanner(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 24.h),
          child: Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20.w,
                ),
              ),
              Expanded(
                child: Text(
                  'Help & Support',
                  style: AppTextStyles.appbar.copyWith(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.support_agent_rounded, color: Colors.white70, size: 28.w),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SupportCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: iconColor, size: 22.w),
            ),
            const Spacer(),
            Text(
              title,
              style: AppTextStyles.bold.copyWith(
                fontSize: 14.sp,
                color: AppColors.current.text,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: AppTextStyles.smallDescription.copyWith(
                fontSize: 11.sp,
                color: AppColors.current.midGray,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickHelpBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.current.primary.withAlpha(20),
            AppColors.current.primary.withAlpha(8),
          ],
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.current.primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.current.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppColors.current.primary,
              size: 22.w,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need immediate help?',
                  style: AppTextStyles.bold.copyWith(
                    fontSize: 13.sp,
                    color: AppColors.current.text,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Our support team typically responds within a few hours.',
                  style: AppTextStyles.smallDescription.copyWith(
                    fontSize: 11.sp,
                    color: AppColors.current.midGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
