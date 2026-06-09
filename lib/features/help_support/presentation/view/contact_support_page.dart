import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/auth_toast.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/utils/custom_text_form_field.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';

import 'package:pettix/core/widgets/app_icon_system.dart';

class ContactSupportPage extends StatefulWidget {
  const ContactSupportPage({super.key});

  @override
  State<ContactSupportPage> createState() => _ContactSupportPageState();
}

class _ContactSupportPageState extends State<ContactSupportPage> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _sending = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _sending = false);
    _subjectController.clear();
    _messageController.clear();
    AuthToast.showSuccess(context, AppText.messageSentSupport);
  }

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
                  _SectionLabel(AppText.reachUsDirectly),
                  SizedBox(height: 12.h),
                  _ContactCard(
                    icon: Icons.chat_bubble_rounded,
                    iconColor: const Color(0xFF10B981),
                    iconBg: const Color(0xFFECFDF5),
                    title: AppText.liveChat,
                    subtitle: AppText.liveChatSubtitle,
                    actionLabel: AppText.chatNow,
                    onAction: () {},
                  ),
                  SizedBox(height: 12.h),
                  _ContactCard(
                    icon: Icons.email_outlined,
                    iconColor: const Color(0xFF5379B2),
                    iconBg: const Color(0xFFEEF2FF),
                    title: AppText.emailSupport,
                    subtitle: AppText.emailSupportSubtitle,
                    actionLabel: AppText.sendEmail,
                    onAction: () {},
                  ),
                  SizedBox(height: 12.h),
                  _ContactCard(
                    icon: Icons.phone_outlined,
                    iconColor: const Color(0xFFF97316),
                    iconBg: const Color(0xFFFFF7ED),
                    title: AppText.phoneSupport,
                    subtitle: AppText.phoneSupportSubtitle,
                    actionLabel: AppText.call,
                    onAction: () {},
                  ),
                  SizedBox(height: 28.h),
                  _SectionLabel(AppText.sendUsMessage),
                  SizedBox(height: 12.h),
                  _MessageForm(
                    formKey: _formKey,
                    subjectController: _subjectController,
                    messageController: _messageController,
                    sending: _sending,
                    onSend: _send,
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
                  AppText.contactSupport,
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

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;

  const _ContactCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: AppIcon.raw(icon, color: iconColor, size: 22.w),
          ),
          SizedBox(width: 12.w),
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
                SizedBox(height: 3.h),
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
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: onAction,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: iconColor.withAlpha(20),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: iconColor.withAlpha(60)),
              ),
              child: Text(
                actionLabel,
                style: AppTextStyles.smallDescription.copyWith(
                  fontSize: 12.sp,
                  color: iconColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController subjectController;
  final TextEditingController messageController;
  final bool sending;
  final VoidCallback onSend;

  const _MessageForm({
    required this.formKey,
    required this.subjectController,
    required this.messageController,
    required this.sending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FieldLabel(AppText.subject),
            SizedBox(height: 8.h),
            CustomTextFormField(
              controller: subjectController,
              hintText: AppText.briefIssueSummary,
              validator:
                  (v) => (v == null || v.isEmpty) ? AppText.required : null,
              fillColor: true,
              fillColorValue: AppColors.current.lightBlue,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.current.lightGray),
              ),
            ),
            SizedBox(height: 16.h),
            _FieldLabel(AppText.message),
            SizedBox(height: 8.h),
            TextFormField(
              controller: messageController,
              maxLines: 5,
              validator:
                  (v) => (v == null || v.isEmpty) ? AppText.required : null,
              style: TextStyle(fontSize: 13.sp, color: AppColors.current.text),
              decoration: InputDecoration(
                hintText: AppText.describeIssueQuestion,
                hintStyle: TextStyle(
                  color: AppColors.current.midGray,
                  fontSize: 13.sp,
                ),
                filled: true,
                fillColor: AppColors.current.lightBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.current.lightGray),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: AppColors.current.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: EdgeInsets.all(14.w),
              ),
            ),
            SizedBox(height: 20.h),
            CustomFilledButton(
              isLoading: sending,
              onPressed: onSend,
              text: AppText.sendMessage,
              backgroundColor: AppColors.current.primary,
              textColor: AppColors.current.white,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: AppTextStyles.smallDescription.copyWith(
      fontSize: 10.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.current.midGray,
      letterSpacing: 0.8,
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: AppTextStyles.smallDescription.copyWith(
      fontSize: 13.sp,
      color: AppColors.current.midGray,
    ),
  );
}
