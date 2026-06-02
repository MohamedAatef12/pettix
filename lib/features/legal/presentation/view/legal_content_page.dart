import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';

// ─── Reusable page for Privacy Policy, Terms & Conditions, Refund Policy ───────

class LegalContentPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String lastUpdated;
  final List<LegalSection> sections;

  const LegalContentPage({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.lastUpdated,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.current.lightBlue,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
              children: [
                // Last updated badge
                Row(
                  children: [
                    Icon(
                      Icons.update_rounded,
                      size: 13.w,
                      color: AppColors.current.midGray,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      AppText.lastUpdated(lastUpdated),
                      style: AppTextStyles.smallDescription.copyWith(
                        fontSize: 11.sp,
                        color: AppColors.current.midGray,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                ...sections.map((s) => _SectionCard(section: s)),
              ],
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
          padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 20.h),
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
                  title,
                  style: AppTextStyles.appbar.copyWith(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(icon, color: Colors.white70, size: 24.w),
            ],
          ),
        ),
      ),
    );
  }
}

class LegalSection {
  final String title;
  final String body;
  const LegalSection({required this.title, required this.body});
}

class _SectionCard extends StatefulWidget {
  final LegalSection section;
  const _SectionCard({required this.section});

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = true;
  late AnimationController _ctrl;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.forward(); // start expanded
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(7),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                setState(() => _expanded = !_expanded);
                _expanded ? _ctrl.forward() : _ctrl.reverse();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.section.title,
                        style: AppTextStyles.bold.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.current.text,
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: _rotation,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.current.primary,
                        size: 20.w,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState:
                  _expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: AppColors.current.lightBlue, height: 1),
                    SizedBox(height: 12.h),
                    Text(
                      widget.section.body,
                      style: AppTextStyles.smallDescription.copyWith(
                        fontSize: 13.sp,
                        color: AppColors.current.midGray,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Pre-built pages ──────────────────────────────────────────────────────────

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) => LegalContentPage(
    title: AppText.privacyPolicyTitle,
    icon: Icons.shield_outlined,
    iconColor: const Color(0xFF10B981),
    lastUpdated: AppText.legalLastUpdatedDate,
    sections: [
      LegalSection(
        title: AppText.informationWeCollect,
        body: AppText.informationWeCollectBody,
      ),
      LegalSection(
        title: AppText.howWeUseInformation,
        body: AppText.howWeUseInformationBody,
      ),
      LegalSection(
        title: AppText.informationSharing,
        body: AppText.informationSharingBody,
      ),
      LegalSection(title: AppText.dataSecurity, body: AppText.dataSecurityBody),
      LegalSection(title: AppText.yourRights, body: AppText.yourRightsBody),
      LegalSection(
        title: AppText.cookiesTracking,
        body: AppText.cookiesTrackingBody,
      ),
      LegalSection(
        title: AppText.changesToPolicy,
        body: AppText.changesToPolicyBody,
      ),
    ],
  );
}

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) => LegalContentPage(
    title: AppText.termsConditions,
    icon: Icons.gavel_rounded,
    iconColor: const Color(0xFF7A6FD8),
    lastUpdated: AppText.legalLastUpdatedDate,
    sections: [
      LegalSection(
        title: AppText.acceptanceOfTerms,
        body: AppText.acceptanceOfTermsBody,
      ),
      LegalSection(title: AppText.userAccounts, body: AppText.userAccountsBody),
      LegalSection(
        title: AppText.prohibitedActivities,
        body: AppText.prohibitedActivitiesBody,
      ),
      LegalSection(
        title: AppText.intellectualProperty,
        body: AppText.intellectualPropertyBody,
      ),
      LegalSection(
        title: AppText.limitationOfLiability,
        body: AppText.limitationOfLiabilityBody,
      ),
      LegalSection(title: AppText.termination, body: AppText.terminationBody),
      LegalSection(title: AppText.governingLaw, body: AppText.governingLawBody),
    ],
  );
}

class RefundPolicyPage extends StatelessWidget {
  const RefundPolicyPage({super.key});

  @override
  Widget build(BuildContext context) => LegalContentPage(
    title: AppText.refundPolicy,
    icon: Icons.assignment_return_outlined,
    iconColor: const Color(0xFFF97316),
    lastUpdated: AppText.legalLastUpdatedDate,
    sections: [
      LegalSection(title: AppText.returnWindow, body: AppText.returnWindowBody),
      LegalSection(
        title: AppText.refundProcess,
        body: AppText.refundProcessBody,
      ),
      LegalSection(
        title: AppText.nonRefundableItems,
        body: AppText.nonRefundableItemsBody,
      ),
      LegalSection(
        title: AppText.shippingCosts,
        body: AppText.shippingCostsBody,
      ),
      LegalSection(
        title: AppText.damagedDefectiveItems,
        body: AppText.damagedDefectiveItemsBody,
      ),
      LegalSection(
        title: AppText.orderCancellations,
        body: AppText.orderCancellationsBody,
      ),
    ],
  );
}
