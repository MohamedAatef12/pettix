import 'package:easy_localization/easy_localization.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/shimmers/report_shimmer.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/auth_toast.dart';
import 'package:pettix/core/widgets/app_profile_image.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';

IconData _getReasonIcon(String name) {
  final n = name.toLowerCase();
  if (n.contains('spam')) return Icons.mail_outline_rounded;
  if (n.contains('harass') || n.contains('abuse')) return Icons.gavel_rounded;
  if (n.contains('hate')) return Icons.sentiment_very_dissatisfied_rounded;
  if (n.contains('nudity') || n.contains('inappropriate') || n.contains('sexual')) return Icons.visibility_off_outlined;
  if (n.contains('violence') || n.contains('harm')) return Icons.warning_amber_rounded;
  if (n.contains('intellectual') || n.contains('copyright')) return Icons.copyright_rounded;
  if (n.contains('false') || n.contains('misleading')) return Icons.error_outline_rounded;
  if (n.contains('other')) return Icons.more_horiz_rounded;
  return Icons.flag_outlined;
}

String _formatCreationDate(String rawDate) {
  try {
    final dateTime = DateTime.parse(rawDate).toLocal();
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inSeconds < 60) return AppText.justNow;
    if (diff.inMinutes < 60) return AppText.minutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return AppText.hoursAgo(diff.inHours);
    if (diff.inDays < 7) return AppText.daysAgo(diff.inDays);
    return DateFormat('MMM d, yyyy').format(dateTime);
  } catch (_) {
    return rawDate;
  }
}

class PostCardHeader extends StatelessWidget {
  const PostCardHeader({
    super.key,
    required this.post,
    required this.isDetailView,
  });

  final PostEntity post;
  final bool isDetailView;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppProfileImage(
          imageUrl: post.author.avatar,
          radius: 30,
          heroTag: 'user_avatar_${post.author.id}',
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 180.w,
              child: Text(
                post.author.nameEn.toString(),
                style: AppTextStyles.bold,
              ),
            ),
            Text(
              _formatCreationDate(post.creationDate),
              style: AppTextStyles.description.copyWith(
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            final homeBloc = context.read<HomeBloc>();
            homeBloc.add(GetReportReasonsEvent());
            showModalBottomSheet(
              backgroundColor: AppColors.current.white,
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
              ),
              builder: (_) {
                return BlocProvider.value(
                  value: homeBloc,
                  child: BlocBuilder<HomeBloc, HomeState>(
                    buildWhen:
                        (p, c) =>
                            p.reportReasons != c.reportReasons ||
                            p.isReportLoading != c.isReportLoading,
                    builder: (context, state) {
                      return DraggableScrollableSheet(
                        expand: false,
                        initialChildSize: 0.8,
                        minChildSize: 0.5,
                        maxChildSize: 0.95,
                        builder: (_, controller) {
                          if (state.isReportLoading) {
                            return const ReportShimmer();
                          }

                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.h,
                                ),
                                child: Container(
                                  width: 40.w,
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.current.lightGray,
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20.w, 4.h, 12.w, 12.h),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(width: 28.w),
                                        Text(
                                          'Report Post'.tr(),
                                          style: AppTextStyles.bold.copyWith(
                                            fontSize: 18.sp,
                                            color: AppColors.current.text,
                                          ),
                                        ),
                                        IconButton(
                                          constraints: const BoxConstraints(),
                                          padding: EdgeInsets.zero,
                                          onPressed: () => Navigator.pop(context),
                                          icon: Icon(
                                            Icons.close_rounded,
                                            color: AppColors.current.midGray,
                                            size: 24.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.h),
                                    Container(
                                      padding: EdgeInsets.all(12.r),
                                      decoration: BoxDecoration(
                                        color: AppColors.current.red.withValues(alpha: 0.05),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline_rounded,
                                            color: AppColors.current.red,
                                            size: 20.r,
                                          ),
                                          SizedBox(width: 10.w),
                                          Expanded(
                                            child: Text(
                                              'Your report is anonymous. We will review this post according to our community guidelines.'
                                                  .tr(),
                                              style: AppTextStyles.description.copyWith(
                                                fontSize: 12.sp,
                                                color: AppColors.current.text,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  controller: controller,
                                  itemCount: state.reportReasons.length,
                                  separatorBuilder:
                                      (_, __) => Divider(
                                        height: 1.h,
                                        thickness: 1.h,
                                        color: AppColors.current.lightGray.withValues(alpha: 0.3),
                                      ),
                                  itemBuilder: (context, index) {
                                    final reason = state.reportReasons[index];
                                    final isOther = reason.name
                                        .toLowerCase()
                                        .contains('other');
                                    final textController = TextEditingController();

                                    return ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 4.h,
                                      ),
                                      leading: Container(
                                        padding: EdgeInsets.all(8.r),
                                        decoration: BoxDecoration(
                                          color: AppColors.current.red.withValues(alpha: 0.08),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _getReasonIcon(reason.name),
                                          color: AppColors.current.red,
                                          size: 20.r,
                                        ),
                                      ),
                                      title: Text(
                                        reason.name.tr(),
                                        style: AppTextStyles.bold.copyWith(
                                          fontSize: 14.sp,
                                          color: AppColors.current.text,
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14.r,
                                        color: AppColors.current.midGray.withValues(alpha: 0.6),
                                      ),
                                      onTap: () {
                                        if (isOther) {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                backgroundColor: AppColors.current.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(16.r),
                                                ),
                                                title: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.report_gmailerrorred_rounded,
                                                      color: AppColors.current.red,
                                                      size: 24.r,
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Text(
                                                      'Specify Report Reason'.tr(),
                                                      style: AppTextStyles.bold.copyWith(
                                                        fontSize: 16.sp,
                                                        color: AppColors.current.text,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                content: TextField(
                                                  controller: textController,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: AppColors.current.text,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText: 'Type your reason here...'.tr(),
                                                    hintStyle: TextStyle(
                                                      color: AppColors.current.midGray,
                                                      fontSize: 12.sp,
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
                                                      borderSide: BorderSide(color: AppColors.current.primary, width: 1.5),
                                                    ),
                                                    contentPadding: EdgeInsets.all(12.w),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(ctx),
                                                    child: Text(
                                                      'Cancel'.tr(),
                                                      style: TextStyle(
                                                        color: AppColors.current.red,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      final customReason = textController.text.trim();
                                                      if (customReason.isNotEmpty) {
                                                        context.read<HomeBloc>().add(
                                                          ReportPostEvent(
                                                            post.id,
                                                            reason.id,
                                                            customReason,
                                                          ),
                                                        );
                                                        Navigator.pop(ctx); // close dialog
                                                        Navigator.pop(context); // close sheet
                                                        AuthToast.showSuccess(
                                                          context,
                                                          AppText.reportSentSuccessfully,
                                                        );
                                                      }
                                                    },
                                                    child: Text(
                                                      'Submit'.tr(),
                                                      style: TextStyle(
                                                        color: AppColors.current.primary,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } else {
                                          context.read<HomeBloc>().add(
                                            ReportPostEvent(
                                              post.id,
                                              reason.id,
                                              reason.name,
                                            ),
                                          );
                                          Navigator.pop(context);
                                          AuthToast.showSuccess(
                                            context,
                                            AppText.reportSentSuccessfully,
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
          child: Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: AppColors.current.lightBlue,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/more.svg',
              width: 18.w,
              height: 18.w,
            ),
          ),
        ),
      ),
    ],
  );
}
}
