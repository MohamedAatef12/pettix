import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_logo.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';

class AboutPettixPage extends StatelessWidget {
  const AboutPettixPage({super.key});

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
                children: [
                  // App logo + version card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 28.h),
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppLogo(size: 36.w),
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
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.current.primary.withAlpha(15),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            AppText.versionNumber('1.0.0'),
                            style: AppTextStyles.smallDescription.copyWith(
                              fontSize: 12.sp,
                              color: AppColors.current.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Mission
                  _InfoCard(
                    icon: Icons.flag_outlined,
                    iconColor: AppColors.current.primary,
                    title: AppText.ourMission,
                    child: Text(
                      AppText.ourMissionBody,
                      style: AppTextStyles.smallDescription.copyWith(
                        fontSize: 13.sp,
                        color: AppColors.current.midGray,
                        height: 1.7,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Features
                  _InfoCard(
                    icon: Icons.star_outline_rounded,
                    iconColor: AppColors.current.gold,
                    title: AppText.features,
                    child: Column(
                      children: [
                        _FeatureRow(
                          Icons.dynamic_feed_rounded,
                          AppText.shareMomentsCommunity,
                          const Color(0xFF5379B2),
                        ),
                        _FeatureRow(
                          Icons.pets_rounded,
                          AppText.findPetsForAdoption,
                          const Color(0xFF10B981),
                        ),
                        _FeatureRow(
                          Icons.local_hospital_outlined,
                          AppText.accessEmergencyVetServices,
                          const Color(0xFFEF4444),
                        ),
                        _FeatureRow(
                          Icons.storefront_rounded,
                          AppText.shopVerifiedPetStores,
                          const Color(0xFFF97316),
                        ),
                        _FeatureRow(
                          Icons.chat_bubble_outline_rounded,
                          AppText.connectOtherPetOwners,
                          const Color(0xFFA855F7),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Contact
                  _InfoCard(
                    icon: Icons.contact_mail_outlined,
                    iconColor: const Color(0xFF10B981),
                    title: AppText.contactUs,
                    child: Column(
                      children: [
                        _ContactRow(Icons.email_outlined, AppText.supportEmail),
                        SizedBox(height: 8.h),
                        _ContactRow(Icons.language_rounded, AppText.websiteUrl),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
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
                  AppText.aboutPettix,
                  style: AppTextStyles.appbar.copyWith(
                    color: AppColors.current.text,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget child;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Icon(icon, color: iconColor, size: 18.w),
              ),
              SizedBox(width: 10.w),
              Text(
                title,
                style: AppTextStyles.bold.copyWith(
                  fontSize: 15.sp,
                  color: AppColors.current.text,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          child,
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  const _FeatureRow(this.icon, this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 14.w),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.smallDescription.copyWith(
                fontSize: 13.sp,
                color: AppColors.current.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.w, color: AppColors.current.midGray),
        SizedBox(width: 10.w),
        Text(
          text,
          style: AppTextStyles.smallDescription.copyWith(
            fontSize: 13.sp,
            color: AppColors.current.text,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
