import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/auth_toast.dart';
import 'package:pettix/core/utils/custom_button.dart';
import 'package:pettix/features/help_support/domain/entities/feedback_entity.dart';
import 'package:pettix/features/help_support/presentation/bloc/feedback_bloc.dart';
import 'package:pettix/features/help_support/presentation/bloc/feedback_event.dart';
import 'package:pettix/features/help_support/presentation/bloc/feedback_state.dart';

class SendFeedbackPage extends StatefulWidget {
  const SendFeedbackPage({super.key});

  @override
  State<SendFeedbackPage> createState() => _SendFeedbackPageState();
}

class _SendFeedbackPageState extends State<SendFeedbackPage> {
  int _selectedType = 0;
  int _rating = 0;
  int _selectedArea = 0;
  bool _followUp = false;
  bool _submitting = false;
  final _feedbackController = TextEditingController();

  static const _types = [
    _Chip('Feature Request', Icons.lightbulb_outline_rounded, Color(0xFFF97316)),
    _Chip('Bug Report', Icons.bug_report_outlined, Color(0xFFEF4444)),
    _Chip('UX / Design', Icons.palette_outlined, Color(0xFFA855F7)),
    _Chip('Improvement', Icons.trending_up_rounded, Color(0xFF10B981)),
    _Chip('Performance', Icons.speed_rounded, Color(0xFF5379B2)),
    _Chip('Other', Icons.more_horiz_rounded, Color(0xFF6B7280)),
  ];

  static const _areas = [
    'Select an area',
    'Home Feed',
    'Adoption',
    'Store',
    'Chat',
    'Profile',
    'Notifications',
    'Settings',
    'Other',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_rating == 0) {
      AuthToast.showError(context, 'Please select a rating.');
      return;
    }
    if (_selectedArea == 0) {
      AuthToast.showError(context, 'Please select an area of the app.');
      return;
    }
    if (_feedbackController.text.trim().isEmpty) {
      AuthToast.showError(context, 'Please write your feedback before submitting.');
      return;
    }

    final feedback = FeedbackEntity(
      feedbackType: _types[_selectedType].label,
      rating: _rating,
      appArea: _areas[_selectedArea],
      description: _feedbackController.text.trim(),
      followUp: _followUp,
    );

    context.read<FeedbackBloc>().add(SubmitFeedbackEvent(feedback));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackBloc, FeedbackState>(
      listener: (context, state) {
        if (state.status == FeedbackStatus.loading) {
          setState(() => _submitting = true);
        } else if (state.status == FeedbackStatus.success) {
          setState(() => _submitting = false);
          AuthToast.showSuccess(context, 'Thank you for your feedback! 🎉');
          context.pop();
        } else if (state.status == FeedbackStatus.error) {
          setState(() => _submitting = false);
          AuthToast.showError(
            context,
            state.errorMessage ?? 'An error occurred. Please try again.',
          );
        }
      },
      child: Scaffold(
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
                    // Type chips
                    _SectionLabel('What type of feedback?'),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: List.generate(_types.length, (i) {
                        final selected = _selectedType == i;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedType = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: selected ? _types[i].color : AppColors.current.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: selected ? _types[i].color : AppColors.current.lightGray,
                              ),
                              boxShadow: selected
                                  ? [BoxShadow(color: _types[i].color.withAlpha(50), blurRadius: 8, offset: const Offset(0, 2))]
                                  : [],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_types[i].icon, size: 14.w,
                                    color: selected ? Colors.white : _types[i].color),
                                SizedBox(width: 6.w),
                                Text(_types[i].label,
                                    style: AppTextStyles.smallDescription.copyWith(
                                      fontSize: 12.sp,
                                      color: selected ? Colors.white : AppColors.current.text,
                                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                                    )),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 24.h),

                    // Star rating
                    _Card(children: [
                      Text(
                        'How would you rate your experience?',
                        style: AppTextStyles.bold.copyWith(fontSize: 14.sp, color: AppColors.current.text),
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (i) {
                          return GestureDetector(
                            onTap: () => setState(() => _rating = i + 1),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 150),
                                child: Icon(
                                  i < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                                  key: ValueKey('$i-${i < _rating}'),
                                  color: i < _rating ? AppColors.current.gold : AppColors.current.lightGray,
                                  size: 38.r,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 6.h),
                      Center(
                        child: Text(
                          _rating == 0
                              ? 'Tap a star to rate'
                              : ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'][_rating],
                          style: AppTextStyles.smallDescription.copyWith(
                            fontSize: 12.sp,
                            color: _rating == 0 ? AppColors.current.midGray : AppColors.current.gold,
                            fontWeight: _rating > 0 ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ]),
                    SizedBox(height: 16.h),

                    // Area dropdown + feedback text
                    _Card(children: [
                      _FieldLabel('Which area of the app?'),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          color: AppColors.current.lightBlue,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.current.lightGray),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _selectedArea,
                            isExpanded: true,
                            icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.current.midGray),
                            style: TextStyle(fontSize: 13.sp, color: AppColors.current.text),
                            items: List.generate(_areas.length, (i) => DropdownMenuItem(
                                  value: i,
                                  child: Text(_areas[i],
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: i == 0 ? AppColors.current.midGray : AppColors.current.text,
                                      )),
                                )),
                            onChanged: (v) => setState(() => _selectedArea = v ?? 0),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _FieldLabel('Your Feedback'),
                      SizedBox(height: 8.h),
                      TextFormField(
                        controller: _feedbackController,
                        maxLines: 5,
                        style: TextStyle(fontSize: 13.sp, color: AppColors.current.text),
                        decoration: InputDecoration(
                          hintText: 'Tell us what you think, what you\'d like to see, or how we can improve...',
                          hintStyle: TextStyle(color: AppColors.current.midGray, fontSize: 12.sp),
                          filled: true,
                          fillColor: AppColors.current.lightBlue,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: AppColors.current.lightGray)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: AppColors.current.primary, width: 1.5)),
                          contentPadding: EdgeInsets.all(12.w),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Follow up with me',
                                    style: AppTextStyles.bold.copyWith(fontSize: 13.sp, color: AppColors.current.text)),
                                SizedBox(height: 2.h),
                                Text("We'll reach out if we have questions about your feedback",
                                    style: AppTextStyles.smallDescription.copyWith(
                                        fontSize: 11.sp, color: AppColors.current.midGray)),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            value: _followUp,
                            onChanged: (v) => setState(() => _followUp = v),
                            activeThumbColor: AppColors.current.white,
                            activeTrackColor: AppColors.current.primary,
                          ),
                        ],
                      ),
                    ]),
                    SizedBox(height: 24.h),
                    CustomFilledButton(
                      isLoading: _submitting,
                      onPressed: _submit,
                      text: 'Send Feedback',
                      backgroundColor: AppColors.current.primary,
                      textColor: AppColors.current.white,
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
                  'Send Feedback',
                  style: AppTextStyles.appbar.copyWith(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600),
                ),
              ),
              Icon(Icons.rate_review_rounded, color: Colors.white70, size: 26.w),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip {
  final String label;
  final IconData icon;
  final Color color;
  const _Chip(this.label, this.icon, this.color);
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
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
          fontSize: 10.sp, fontWeight: FontWeight.w700,
          color: AppColors.current.midGray, letterSpacing: 0.8,
        ),
      );
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppTextStyles.smallDescription.copyWith(fontSize: 13.sp, color: AppColors.current.midGray),
      );
}
