import 'package:easy_localization/easy_localization.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/shimmers/report_shimmer.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/pet_toast.dart';
import 'package:pettix/core/utils/date_formatter.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';
import 'package:pettix/core/widgets/app_profile_image.dart';
import 'package:pettix/core/widgets/rtl_aware_icon.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';

AppIconToken _getReasonIcon(String name) {
  final n = name.toLowerCase();
  if (n.contains('spam')) return AppIconToken.reportSpam;
  if (n.contains('harass') || n.contains('abuse')) {
    return AppIconToken.reportHarassment;
  }
  if (n.contains('hate')) return AppIconToken.reportHate;
  if (n.contains('nudity') ||
      n.contains('inappropriate') ||
      n.contains('sexual')) {
    return AppIconToken.reportHidden;
  }
  if (n.contains('violence') || n.contains('harm')) {
    return AppIconToken.reportWarning;
  }
  if (n.contains('intellectual') || n.contains('copyright')) {
    return AppIconToken.reportCopyright;
  }
  if (n.contains('false') || n.contains('misleading')) {
    return AppIconToken.reportFalse;
  }
  if (n.contains('other')) return AppIconToken.reportOther;
  return AppIconToken.report;
}

class PostCardHeader extends StatelessWidget {
  const PostCardHeader({
    super.key,
    required this.post,
    required this.isDetailView,
    this.showOwnerActions = false,
  });

  final PostEntity post;
  final bool isDetailView;
  final bool showOwnerActions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppProfileImage(imageUrl: post.author.avatar, radius: 30),
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
              DateFormatter.formatRelativeTime(context, post.creationDate),
              style: AppTextStyles.description.copyWith(fontSize: 12.sp),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            if (showOwnerActions) {
              _showOwnerActions(context);
              return;
            }

            final homeBloc = context.read<HomeBloc>();
            homeBloc.add(GetReportReasonsEvent());
            showModalBottomSheet(
              backgroundColor: AppColors.current.white,
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
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
                        initialChildSize: 0.65,
                        minChildSize: 0.45,
                        maxChildSize: 0.9,
                        builder: (_, controller) {
                          if (state.isReportLoading) {
                            return SizedBox(
                              height: 500.h,
                              child: const ReportShimmer(),
                            );
                          }

                          return SafeArea(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        AppText.reportPost,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.bold.copyWith(
                                          fontSize: 18.sp,
                                          color: AppColors.current.text,
                                        ),
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        AppText.reportAnonymousNote,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: AppColors.current.lightText,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Expanded(
                                  child: ListView.builder(
                                    controller: controller,
                                    padding: EdgeInsets.only(bottom: 24.h),
                                    itemCount: state.reportReasons.length,
                                    itemBuilder: (context, index) {
                                      final reason = state.reportReasons[index];
                                      final isOther = reason.name
                                          .toLowerCase()
                                          .contains('other');
                                      final textController =
                                          TextEditingController();

                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 6.h,
                                          horizontal: 20.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.current.white,
                                          borderRadius: BorderRadius.circular(
                                            14.r,
                                          ),
                                          border: Border.all(
                                            color: AppColors.current.lightGray
                                                .withValues(alpha: 0.4),
                                            width: 1.r,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.015,
                                              ),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 2.h,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14.r,
                                            ),
                                          ),
                                          leading: CircleAvatar(
                                            radius: 18.r,
                                            backgroundColor: AppColors
                                                .current
                                                .red
                                                .withValues(alpha: 0.08),
                                            child: AppIcon(
                                              token: _getReasonIcon(
                                                reason.name,
                                              ),
                                              color: AppColors.current.red
                                                  .withValues(alpha: 0.8),
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
                                          trailing: RtlAwareIcon(
                                            child: AppIcon(
                                              token:
                                                  AppIconToken.chevronForward,
                                              size: 14.r,
                                              color: AppColors.current.lightText
                                                  .withValues(alpha: 0.6),
                                            ),
                                          ),
                                          onTap: () {
                                            if (isOther) {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return Dialog(
                                                    backgroundColor:
                                                        AppColors.current.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20.r,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                        20.r,
                                                      ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          Text(
                                                            AppText
                                                                .reportAnonymousNote,
                                                            style: AppTextStyles
                                                                .bold
                                                                .copyWith(
                                                                  fontSize:
                                                                      18.sp,
                                                                  color:
                                                                      AppColors
                                                                          .current
                                                                          .text,
                                                                ),
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                          ),
                                                          SizedBox(height: 8.h),
                                                          Text(
                                                            AppText
                                                                .specifyReportReason,
                                                            style: TextStyle(
                                                              fontSize: 13.sp,
                                                              color:
                                                                  AppColors
                                                                      .current
                                                                      .lightText,
                                                              height: 1.4,
                                                            ),
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                          ),
                                                          SizedBox(
                                                            height: 16.h,
                                                          ),
                                                          TextField(
                                                            controller:
                                                                textController,
                                                            maxLines: 3,
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                              color:
                                                                  AppColors
                                                                      .current
                                                                      .text,
                                                            ),
                                                            decoration: InputDecoration(
                                                              hintText:
                                                                  AppText
                                                                      .typeReasonHere,
                                                              hintStyle: TextStyle(
                                                                fontSize: 14.sp,
                                                                color: AppColors
                                                                    .current
                                                                    .lightText
                                                                    .withValues(
                                                                      alpha:
                                                                          0.6,
                                                                    ),
                                                              ),
                                                              filled: true,
                                                              fillColor: AppColors
                                                                  .current
                                                                  .lightBlue
                                                                  .withValues(
                                                                    alpha: 0.3,
                                                                  ),
                                                              contentPadding:
                                                                  EdgeInsets.all(
                                                                    12.r,
                                                                  ),
                                                              border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      12.r,
                                                                    ),
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      AppColors
                                                                          .current
                                                                          .lightGray,
                                                                  width: 1.r,
                                                                ),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      12.r,
                                                                    ),
                                                                borderSide: BorderSide(
                                                                  color: AppColors
                                                                      .current
                                                                      .lightGray
                                                                      .withValues(
                                                                        alpha:
                                                                            0.5,
                                                                      ),
                                                                  width: 1.r,
                                                                ),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      12.r,
                                                                    ),
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      AppColors
                                                                          .current
                                                                          .primary,
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20.h,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: OutlinedButton(
                                                                  onPressed:
                                                                      () =>
                                                                          Navigator.pop(
                                                                            ctx,
                                                                          ),
                                                                  style: OutlinedButton.styleFrom(
                                                                    side: BorderSide(
                                                                      color:
                                                                          AppColors
                                                                              .current
                                                                              .lightGray,
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          12.h,
                                                                    ),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            12.r,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    AppText
                                                                        .cancel,
                                                                    style: TextStyle(
                                                                      color:
                                                                          AppColors
                                                                              .current
                                                                              .text,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 12.w,
                                                              ),
                                                              Expanded(
                                                                child: ElevatedButton(
                                                                  onPressed: () {
                                                                    final customReason =
                                                                        textController
                                                                            .text
                                                                            .trim();
                                                                    if (customReason
                                                                        .isNotEmpty) {
                                                                      context
                                                                          .read<
                                                                            HomeBloc
                                                                          >()
                                                                          .add(
                                                                            ReportPostEvent(
                                                                              post.id,
                                                                              reason.id,
                                                                              customReason,
                                                                            ),
                                                                          );
                                                                      Navigator.pop(
                                                                        ctx,
                                                                      );
                                                                      PetToast.showSuccess(
                                                                        context,
                                                                        AppText
                                                                            .reportSentSuccessfully,
                                                                      );
                                                                    }
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .current
                                                                            .primary,
                                                                    elevation:
                                                                        0,
                                                                    padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          12.h,
                                                                    ),
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            12.r,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    AppText
                                                                        .submit,
                                                                    style: const TextStyle(
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
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
                                              PetToast.showSuccess(
                                                context,
                                                AppText.reportSentSuccessfully,
                                              );
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
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
            child: Center(child: AppIcon(token: AppIconToken.more, size: 18.w)),
          ),
        ),
      ],
    );
  }

  void _showOwnerActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.current.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.current.lightGray,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 14.h),
                _OwnerActionTile(
                  icon: Icons.edit_rounded,
                  label: AppText.edit,
                  color: AppColors.current.primary,
                  onTap: () {
                    final homeBloc = context.read<HomeBloc>();
                    Navigator.pop(sheetContext);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.pushNamed(
                        AppRouteNames.addPost,
                        extra: {'bloc': homeBloc, 'editingPost': post},
                      );
                    });
                  },
                ),
                SizedBox(height: 8.h),
                _OwnerActionTile(
                  icon: Icons.delete_outline_rounded,
                  label: AppText.delete,
                  color: AppColors.current.red,
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _confirmDeletePost(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDeletePost(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.current.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
          title: Text(
            AppText.delete,
            style: AppTextStyles.bold.copyWith(color: AppColors.current.text),
          ),
          content: Text(
            AppText.deletePostConfirmation,
            style: AppTextStyles.description.copyWith(
              color: AppColors.current.midGray,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                AppText.cancel,
                style: TextStyle(color: AppColors.current.midGray),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final homeBloc = context.read<HomeBloc>();
                final postId = post.id;
                Navigator.pop(dialogContext);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  homeBloc.add(DeletePostEvent(postId));
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.current.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(AppText.delete),
            ),
          ],
        );
      },
    );
  }
}

class _OwnerActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OwnerActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20.r),
            SizedBox(width: 12.w),
            Text(
              label,
              style: AppTextStyles.bold.copyWith(color: color, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}
