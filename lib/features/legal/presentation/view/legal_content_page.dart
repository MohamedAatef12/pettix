import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
                    Icon(Icons.update_rounded, size: 13.w, color: AppColors.current.midGray),
                    SizedBox(width: 5.w),
                    Text(
                      'Last updated: $lastUpdated',
                      style: AppTextStyles.smallDescription.copyWith(
                        fontSize: 11.sp, color: AppColors.current.midGray,
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
                  title,
                  style: AppTextStyles.appbar.copyWith(
                    color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600,
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

class _SectionCardState extends State<_SectionCard> with SingleTickerProviderStateMixin {
  bool _expanded = true;
  late AnimationController _ctrl;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _rotation = Tween<double>(begin: 0, end: 0.5).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
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
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(7), blurRadius: 8, offset: const Offset(0, 2))],
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
                          fontSize: 14.sp, color: AppColors.current.text,
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: _rotation,
                      child: Icon(Icons.keyboard_arrow_down_rounded,
                          color: AppColors.current.primary, size: 20.w),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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
                        fontSize: 13.sp, color: AppColors.current.midGray, height: 1.7,
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
        title: 'Privacy Policy',
        icon: Icons.shield_outlined,
        iconColor: const Color(0xFF10B981),
        lastUpdated: 'January 30, 2024',
        sections: const [
          LegalSection(
            title: 'Information We Collect',
            body:
                'We collect information you provide directly, such as your name, email address, phone number, and profile photo when you create an account. We also collect usage data, device information, and location data (when you grant permission) to improve our services and personalize your experience.',
          ),
          LegalSection(
            title: 'How We Use Your Information',
            body:
                'We use the information we collect to provide, maintain, and improve our services, process transactions, send notifications, personalize your experience, and communicate with you about updates, promotions, and support.',
          ),
          LegalSection(
            title: 'Information Sharing',
            body:
                'We do not sell your personal information. We may share your information with service providers who assist us in operating our platform, complying with legal obligations, or protecting our rights. We ensure all third parties adhere to appropriate data protection standards.',
          ),
          LegalSection(
            title: 'Data Security',
            body:
                'We implement industry-standard security measures including encryption, secure servers, and regular audits to protect your personal information from unauthorized access, alteration, disclosure, or destruction.',
          ),
          LegalSection(
            title: 'Your Rights',
            body:
                'You have the right to access, update or delete your personal information at any time through your account settings. You may also request a copy of your data or withdraw consent for certain data processing activities.',
          ),
          LegalSection(
            title: 'Cookies & Tracking',
            body:
                'We use cookies and similar tracking technologies to enhance your experience on our platform. You can control cookie preferences through your browser settings. Some features may not function properly if you disable cookies.',
          ),
          LegalSection(
            title: 'Changes to This Policy',
            body:
                'We may update this Privacy Policy from time to time. We will notify you of any significant changes via email or a prominent notice in the app. Continued use of Pettix after changes constitutes your acceptance of the updated policy.',
          ),
        ],
      );
}

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) => LegalContentPage(
        title: 'Terms & Conditions',
        icon: Icons.gavel_rounded,
        iconColor: const Color(0xFF7A6FD8),
        lastUpdated: 'January 30, 2024',
        sections: const [
          LegalSection(
            title: 'Acceptance of Terms',
            body:
                'By accessing and using Pettix, you accept and agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use our platform.',
          ),
          LegalSection(
            title: 'User Accounts',
            body:
                'You are responsible for maintaining the confidentiality of your account credentials. You agree to accept responsibility for all activities that occur under your account and to notify us immediately of any unauthorized use.',
          ),
          LegalSection(
            title: 'Prohibited Activities',
            body:
                'You may not use Pettix for any illegal or unauthorized purpose. Prohibited activities include posting false information, impersonating others, spreading harmful content, attempting to breach security, or engaging in any activity that violates applicable laws.',
          ),
          LegalSection(
            title: 'Intellectual Property',
            body:
                'All content, trademarks, and software on Pettix are the property of Pettix or its content suppliers and are protected by copyright and intellectual property laws. Unauthorized use is strictly prohibited.',
          ),
          LegalSection(
            title: 'Limitation of Liability',
            body:
                'Pettix shall not be liable for any indirect, incidental, special, or consequential damages arising out of or in connection with your use of our services. Our liability is limited to the maximum extent permitted by law.',
          ),
          LegalSection(
            title: 'Termination',
            body:
                'We reserve the right to suspend or terminate your account at any time for violations of these terms or for any other reason at our sole discretion. You may also delete your account at any time through the app settings.',
          ),
          LegalSection(
            title: 'Governing Law',
            body:
                'These Terms shall be governed by and construed in accordance with applicable laws. Any disputes arising under these terms shall be subject to the exclusive jurisdiction of competent courts.',
          ),
        ],
      );
}

class RefundPolicyPage extends StatelessWidget {
  const RefundPolicyPage({super.key});

  @override
  Widget build(BuildContext context) => LegalContentPage(
        title: 'Refund Policy',
        icon: Icons.assignment_return_outlined,
        iconColor: const Color(0xFFF97316),
        lastUpdated: 'January 30, 2024',
        sections: const [
          LegalSection(
            title: 'Return Window',
            body:
                'You may return most items within 14 days of delivery for a full refund. Items must be unused, in the same condition you received them, and in their original packaging to qualify for a return.',
          ),
          LegalSection(
            title: 'Refund Process',
            body:
                'Once we receive your returned item, we will inspect it and process your refund within 5–7 business days. Refunds are issued to the original payment method used at the time of purchase.',
          ),
          LegalSection(
            title: 'Non-Refundable Items',
            body:
                'Certain items are non-refundable, including perishable goods (food, treats), hygiene products, custom-made items, and digital products once downloaded or activated.',
          ),
          LegalSection(
            title: 'Shipping Costs',
            body:
                'Original shipping costs are non-refundable. Return shipping costs are the responsibility of the customer unless the item is defective, damaged, or was sent incorrectly.',
          ),
          LegalSection(
            title: 'Damaged or Defective Items',
            body:
                'If you receive a damaged or defective item, please contact us immediately with photos. We will provide a free replacement or a full refund including shipping costs at no additional charge to you.',
          ),
          LegalSection(
            title: 'Order Cancellations',
            body:
                'Orders can be cancelled within 2 hours of placement for a full refund. Once the order has been processed and shipped, cancellations are no longer possible and the standard return process applies.',
          ),
        ],
      );
}
