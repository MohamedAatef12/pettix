import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/auth_toast.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';
import 'package:pettix/features/help_support/domain/entities/problem_report_entity.dart';
import 'package:pettix/features/help_support/presentation/bloc/problem_report_bloc.dart';
import 'package:pettix/features/help_support/presentation/bloc/problem_report_event.dart';
import 'package:pettix/features/help_support/presentation/bloc/problem_report_state.dart';

import 'package:pettix/core/widgets/app_icon_system.dart';

class ReportProblemPage extends StatefulWidget {
  const ReportProblemPage({super.key});

  @override
  State<ReportProblemPage> createState() => _ReportProblemPageState();
}

class _ReportProblemPageState extends State<ReportProblemPage> {
  int _selectedCategory = 0;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _stepsController = TextEditingController();

  List<_Category> get _categories => [
    _Category('AppCrash', AppText.appCrash, Icons.error_outline_rounded),
    _Category('FeatureIssue', AppText.featureIssue, Icons.tune_rounded),
    _Category('Performance', AppText.performance, Icons.speed_rounded),
    _Category('UiDisplay', AppText.uiDisplay, Icons.phone_android_rounded),
    _Category(
      'Notification',
      AppText.notificationsText,
      Icons.notifications_none_rounded,
    ),
    _Category('AccountLogin', AppText.accountLogin, Icons.lock_outline_rounded),
    _Category('Payments', AppText.payments, Icons.payment_rounded),
    _Category('Other', AppText.other, Icons.more_horiz_rounded),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty ||
        _descController.text.trim().isEmpty) {
      AuthToast.showError(context, AppText.fillTitleDescription);
      return;
    }
    context.read<ProblemReportBloc>().add(
      SubmitProblemReportEvent(
        ProblemReportEntity(
          problemCategory: _categories[_selectedCategory].value,
          problemTitle: _titleController.text.trim(),
          description: _descController.text.trim(),
          stepsToReproduce: _stepsController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProblemReportBloc, ProblemReportState>(
      listener: (context, state) {
        if (state.status == ProblemReportStatus.success) {
          AuthToast.showSuccess(context, AppText.reportSubmittedThanks);
          context.pop();
        } else if (state.status == ProblemReportStatus.error) {
          AuthToast.showError(
            context,
            state.errorMessage ?? AppText.somethingWentWrong,
          );
        }
      },
      builder: (context, state) {
        final submitting = state.status == ProblemReportStatus.loading;

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
                      _SectionLabel(AppText.problemCategory),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: List.generate(_categories.length, (i) {
                          final selected = _selectedCategory == i;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    selected
                                        ? AppColors.current.primary
                                        : AppColors.current.white,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color:
                                      selected
                                          ? AppColors.current.primary
                                          : AppColors.current.lightGray,
                                ),
                                boxShadow:
                                    selected
                                        ? [
                                          BoxShadow(
                                            color: AppColors.current.primary
                                                .withAlpha(40),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                        : [],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppIcon.raw(
                                    _categories[i].icon,
                                    size: 14.w,
                                    color:
                                        selected
                                            ? Colors.white
                                            : AppColors.current.midGray,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    _categories[i].label,
                                    style: AppTextStyles.smallDescription
                                        .copyWith(
                                          fontSize: 12.sp,
                                          color:
                                              selected
                                                  ? Colors.white
                                                  : AppColors.current.text,
                                          fontWeight:
                                              selected
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 24.h),
                      _FormCard(
                        children: [
                          _FieldLabel(AppText.problemTitle),
                          SizedBox(height: 8.h),
                          _InputField(
                            controller: _titleController,
                            hint: AppText.briefIssueSummary,
                          ),
                          SizedBox(height: 16.h),
                          _FieldLabel(AppText.describeProblem),
                          SizedBox(height: 8.h),
                          _InputField(
                            controller: _descController,
                            hint: AppText.whatHappenedHint,
                            maxLines: 4,
                          ),
                          SizedBox(height: 16.h),
                          _FieldLabel(AppText.stepsToReproduceOptional),
                          SizedBox(height: 8.h),
                          _InputField(
                            controller: _stepsController,
                            hint: AppText.stepsToReproduceHint,
                            maxLines: 4,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _DeviceInfoCard(),
                      SizedBox(height: 24.h),
                      CustomFilledButton(
                        isLoading: submitting,
                        onPressed: submitting ? null : _submit,
                        text: AppText.submitReport,
                        backgroundColor: AppColors.current.primary,
                        textColor: AppColors.current.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
                  AppText.reportProblem,
                  style: AppTextStyles.appbar.copyWith(
                    color: AppColors.current.text,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AppIcon.raw(
                Icons.bug_report_rounded,
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

class _Category {
  final String value;
  final String label;
  final IconData icon;
  const _Category(this.value, this.label, this.icon);
}

class _FormCard extends StatelessWidget {
  final List<Widget> children;
  const _FormCard({required this.children});
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  const _InputField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(fontSize: 13.sp, color: AppColors.current.text),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.current.midGray, fontSize: 12.sp),
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
          borderSide: BorderSide(color: AppColors.current.primary, width: 1.5),
        ),
        contentPadding: EdgeInsets.all(12.w),
      ),
    );
  }
}

class _DeviceInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final os =
        Platform.isAndroid
            ? AppText.android
            : Platform.isIOS
            ? AppText.ios
            : AppText.unknown;
    final rows = [
      (AppText.appVersion, '1.0.0'),
      (AppText.platform, os),
      (
        AppText.osBuild,
        Platform.operatingSystemVersion.split(' ').take(3).join(' '),
      ),
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.current.primary.withAlpha(10),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.current.primary.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppIcon.raw(
                Icons.info_outline_rounded,
                size: 16.w,
                color: AppColors.current.primary,
              ),
              SizedBox(width: 6.w),
              Text(
                AppText.deviceInfoAutoDetected,
                style: AppTextStyles.smallDescription.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.current.primary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ...rows.map(
            (r) => Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Row(
                children: [
                  SizedBox(
                    width: 90.w,
                    child: Text(
                      r.$1,
                      style: AppTextStyles.smallDescription.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.current.midGray,
                      ),
                    ),
                  ),
                  Text(
                    r.$2,
                    style: AppTextStyles.smallDescription.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.current.text,
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
