import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/shimmers/report_shimmer.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/rtl_aware_icon.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/pages/comments_page.dart';
import 'package:pettix/features/home/presentation/pages/comments_page.dart';
import 'package:pettix/main/my_app.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';

import '../../../../config/router/routes.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, this.isDetailView = false});

  final PostEntity post;
  final bool isDetailView;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingConstants.horizontalSmall,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: PaddingConstants.medium,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.current.blueGray,
                    backgroundImage:
                        (post.author.avatar != null &&
                                post.author.avatar!.isNotEmpty)
                            ? NetworkImage(post.author.avatar!)
                            : const AssetImage('assets/images/no_user.png')
                                as ImageProvider,
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
                        backgroundColor: AppColors.current.lightBlue,
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.r),
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
                                  initialChildSize: 0.9,
                                  minChildSize: 0.5,
                                  maxChildSize: 0.9,
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
                                            width: 50.w,
                                            height: 4.h,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(2.r),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10.0.r,
                                          ),
                                          child: Text(
                                            'Report Post'.tr(),
                                            style: AppTextStyles.bold.copyWith(
                                              fontSize: 18.sp,
                                              color: AppColors.current.red,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                        Expanded(
                                          child: ListView.separated(
                                            controller: controller,
                                            itemCount:
                                                state.reportReasons.length,
                                            separatorBuilder:
                                                (_, __) => SizedBox(),
                                            itemBuilder: (context, index) {
                                              final reason =
                                                  state.reportReasons[index];
                                              final isOther = reason.name
                                                  .toLowerCase()
                                                  .contains('other');
                                              final textController =
                                                  TextEditingController();

                                              return Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.current.red
                                                        .withOpacity(0.05),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                          Radius.circular(10.r),
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          AppColors.current.red,
                                                      width: 1.h,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text(
                                                          reason.name.tr(),
                                                          style: AppTextStyles
                                                              .bold
                                                              .copyWith(
                                                                color:
                                                                    AppColors
                                                                        .current
                                                                        .text,
                                                              ),
                                                        ),
                                                        onTap: () {
                                                          if (isOther) {
                                                            showDialog(
                                                              context: context,
                                                              builder: (ctx) {
                                                                return AlertDialog(
                                                                  backgroundColor:
                                                                      AppColors
                                                                          .current
                                                                          .lightBlue,
                                                                  title: Text(
                                                                    'Please specify the reason'
                                                                        .tr(),
                                                                  ),
                                                                  content: TextField(
                                                                    controller:
                                                                        textController,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                          hintText:
                                                                              'Type your reason here...',
                                                                        ),
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () => Navigator.pop(
                                                                            ctx,
                                                                          ),
                                                                      child: Text(
                                                                        'Cancel',
                                                                        style: TextStyle(
                                                                          color:
                                                                              AppColors.current.text,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        final customReason =
                                                                            textController.text.trim();
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
                                                                          ); // close dialog
                                                                          Navigator.pop(
                                                                            context,
                                                                          ); // close sheet
                                                                          ScaffoldMessenger.of(
                                                                            context,
                                                                          ).showSnackBar(
                                                                            const SnackBar(
                                                                              content: Text(
                                                                                'Report sent successfully',
                                                                              ),
                                                                              backgroundColor:
                                                                                  Colors.green,
                                                                            ),
                                                                          );
                                                                        }
                                                                      },
                                                                      child: Text(
                                                                        'Submit'
                                                                            .tr(),
                                                                        style: TextStyle(
                                                                          color:
                                                                              AppColors.current.primary,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          } else {
                                                            context
                                                                .read<
                                                                  HomeBloc
                                                                >()
                                                                .add(
                                                                  ReportPostEvent(
                                                                    post.id,
                                                                    reason.id,
                                                                    reason.name,
                                                                  ),
                                                                );
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  'Report sent successfully'
                                                                      .tr(),
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                    child: CircleAvatar(
                      radius: 20.r,
                      backgroundColor: AppColors.current.white,
                      child: SvgPicture.asset('assets/icons/more.svg'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Text(post.content, style: AppTextStyles.description),
              if (post.images.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Builder(
                    builder: (context) {
                      final validImages =
                          post.images.where((e) {
                            // Filter out empty strings
                            if (e.isEmpty) return false;

                            // Filter out backend placeholders like "data:image/png;base64,string"
                            if (e == 'data:image/png;base64,string') {
                              debugPrint(
                                '⚠️ Filtered out placeholder image: $e',
                              );
                              return false;
                            }

                            // Accept valid image formats
                            return e.startsWith('http') ||
                                e.startsWith('data:image') ||
                                File(e).existsSync();
                          }).toList();

                      debugPrint(
                        '📸 Post ${post.id} has ${post.images.length} images, ${validImages.length} valid',
                      );

                      if (validImages.isEmpty) return const SizedBox.shrink();

                      final imagesToShow =
                          validImages.length > 4
                              ? validImages.take(4).toList()
                              : validImages;

                      // ✅ حال صورتين فقط → أفقي جنب بعض
                      if (imagesToShow.length == 2) {
                        return Row(
                          children: List.generate(2, (index) {
                            final image = imagesToShow[index];
                            return Expanded(
                              child: GestureDetector(
                                onTap:
                                    () =>
                                        _openSingleImagePreview(context, image),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: index == 0 ? 8.w : 0,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.r),
                                    child: _buildImage(
                                      context,
                                      image,
                                      height: 200.h,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      }

                      // ✅ باقي الحالات (1 أو أكتر من 2)
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // الصورة الأولى كبيرة
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: GestureDetector(
                              onTap:
                                  () => _openSingleImagePreview(
                                    context,
                                    validImages[0],
                                  ),
                              child: _buildImage(
                                context,
                                imagesToShow[0],
                                height: 300.h,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // باقي الصور
                          if (imagesToShow.length > 1)
                            Row(
                              children:
                                  List.generate(
                                      imagesToShow.length == 2
                                          ? 2
                                          : imagesToShow.length > 3
                                          ? 3
                                          : imagesToShow.length - 1,
                                      (index) {
                                        final actualIndex = index + 1;
                                        final image = imagesToShow[actualIndex];
                                        final isLastWithMore =
                                            actualIndex == 3 &&
                                            validImages.length > 4;

                                        return Expanded(
                                          child: SizedBox(
                                            height: 100.h,
                                            child: GestureDetector(
                                              onTap: () {
                                                if (isLastWithMore) {
                                                  _openImagesPreview(
                                                    context,
                                                    validImages,
                                                  );
                                                } else {
                                                  _openSingleImagePreview(
                                                    context,
                                                    image,
                                                  );
                                                }
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          15.r,
                                                        ),
                                                    child: _buildImage(
                                                      context,
                                                      image,
                                                      height: 100.h,
                                                    ),
                                                  ),
                                                  if (isLastWithMore)
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            15.r,
                                                          ),
                                                      child: BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                              sigmaX: 2,
                                                              sigmaY: 2,
                                                            ),
                                                        child: Container(
                                                          color:
                                                              Colors
                                                                  .transparent,
                                                        ),
                                                      ),
                                                    ),
                                                  if (isLastWithMore)
                                                    Center(
                                                      child: Text(
                                                        '+${validImages.length - 3}',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 24.sp,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          shadows: [
                                                            Shadow(
                                                              blurRadius: 6,
                                                              color:
                                                                  Colors
                                                                      .black54,
                                                              offset: Offset(
                                                                1,
                                                                1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ).expand((w) sync* {
                                      yield w;
                                      yield SizedBox(width: 8.w);
                                    }).toList()
                                    ..removeLast(),
                            ),
                        ],
                      );
                    },
                  ),
                )
              else
                const SizedBox.shrink(),

              BlocBuilder<HomeBloc, HomeState>(
                buildWhen:
                    (prev, curr) =>
                        prev.likedPostIds != curr.likedPostIds ||
                        prev.savedPostIds != curr.savedPostIds ||
                        prev.postLikesCount != curr.postLikesCount ||
                        prev.postCommentsCount != curr.postCommentsCount,
                builder: (context, state) {
                  final homeBloc = context.read<HomeBloc>();
                  final commentsCount = state.postCommentsCount[post.id] ?? post.totalComments;
                  final isLiked = state.likedPostIds.contains(post.id);
                  final isSaved = state.savedPostIds.contains(post.id);
                  final likesCount =
                      state.postLikesCount[post.id] ?? post.likes.length;

                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isLiked) {
                            homeBloc.add(DeleteLikeEvent(post.id));
                          } else {
                            homeBloc.add(AddLikeEvent(post.id, creatorId: post.author.id));
                          }
                        },
                        child: SvgPicture.asset(
                          'assets/icons/like.svg',
                          colorFilter: ColorFilter.mode(
                            isLiked
                                ? AppColors.current.red
                                : AppColors.current.text.withOpacity(0.7),
                            BlendMode.srcIn,
                          ),
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        likesCount.toString(),
                        style: AppTextStyles.description,
                      ),

                      SizedBox(width: 10.w),

                      GestureDetector(
                        onTap: () {
                          if (isDetailView) return;
                          router.push(AppRoutes.comments, extra: {
                            'post': post,
                            'bloc': context.read<HomeBloc>(),
                          });
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/comment.svg',
                              height: 22.h,
                              width: 22.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              commentsCount.toString(),
                              style: AppTextStyles.description,
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      GestureDetector(
                        onTap: () {
                          if (isSaved) {
                            homeBloc.add(UnSavePostEvent(post.id));
                          } else {
                            homeBloc.add(SavePostEvent(post.id));
                          }
                        },
                        child: SvgPicture.asset(
                          'assets/icons/save_post.svg',
                          colorFilter: ColorFilter.mode(
                            isSaved
                                ? AppColors
                                    .current
                                    .yellow // Gold color
                                : AppColors.current.text.withOpacity(0.7),
                            BlendMode.srcIn,
                          ),
                          height: 26.h,
                          width: 26.w,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatCreationDate(String rawDate) {
  try {
    final dateTime = DateTime.parse(rawDate).toLocal();
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d, yyyy').format(dateTime);
  } catch (_) {
    return rawDate;
  }
}

Widget _buildImage(BuildContext context, String image, {double? height}) {
  debugPrint(
    '🖼️ Building image: ${image.substring(0, image.length > 100 ? 100 : image.length)}...',
  );

  // Handle malformed data URLs from backend (e.g., "data:image/png;base64,Resources/PostsUploads/file.jpg")
  if (image.startsWith('data:image') && image.contains('Resources/')) {
    // Extract the file path and construct proper URL
    final filePath = image.split(',').last;
    final properUrl = '${Constants.baseUrl}/$filePath';
    debugPrint('✅ Converted malformed URL to: $properUrl');
    return CachedNetworkImage(
      imageUrl:
      properUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.fill,
      errorWidget: (context, error, stackTrace) {
        debugPrint('❌ Image load error for $properUrl: $error');
        return _errorImage(height);
      },
    );
  } else if (image.startsWith('http')) {
    return CachedNetworkImage(
     imageUrl:  image,
      height: height,
      width: double.infinity,
      fit: BoxFit.fill,
      errorWidget: (_, __, ___) => _errorImage(height),
    );
  } else if (image.startsWith('data:image')) {
    try {
      final base64String = image.split(',').last;
      final bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        height: height,
        width: double.infinity,
        fit: BoxFit.fill,
        errorBuilder: (_, __, ___) => _errorImage(height),
      );
    } catch (_) {
      return _errorImage(height);
    }
  } else if (File(image).existsSync()) {
    return Image.file(
      File(image),
      height: height,
      width: double.infinity,
      fit: BoxFit.fill,
      errorBuilder: (_, __, ___) => _errorImage(height),
    );
  } else {
    return _errorImage(height);
  }
}

Widget _errorImage([double? height]) {
  return Container(
    color: AppColors.current.lightGray,
    height: height ?? 200.h,
    child: const Icon(Icons.broken_image),
  );
}

void _openImagesPreview(BuildContext context, List<String> images) {
  final controller = PageController(initialPage: 0);

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.black.withValues(alpha: 0.8),
    pageBuilder: (_, __, ___) {
      final imageHeight = MediaQuery.of(context).size.height * 0.5;

      return StatefulBuilder(
        builder: (context, setState) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: imageHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: PageView.builder(
                              controller: controller,
                              itemCount: images.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: InteractiveViewer(
                                    child: _buildImage(
                                      context,
                                      images[index],
                                      height: imageHeight,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 10.w),
                        IconButton(
                          icon: RtlAwareIcon(
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          onPressed: () {
                            if (controller.page! > 0) {
                              controller.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                        SmoothPageIndicator(
                          controller: controller,
                          count: images.length,
                          effect: ExpandingDotsEffect(
                            activeDotColor: Colors.white,
                            dotColor: Colors.white54,
                            dotHeight: 8,
                            dotWidth: 8,
                            expansionFactor: 3,
                          ),
                        ),
                        IconButton(
                          icon: RtlAwareIcon(
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          onPressed: () {
                            if (controller.page! < images.length - 1) {
                              controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                        SizedBox(width: 10.w),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void _openSingleImagePreview(BuildContext context, String image) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.8),
    builder: (_) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(12.r),
        child: ClipRRect(
          child: InteractiveViewer(
            child: _buildImage(
              context,
              image,
              height:
                  MediaQuery.of(context).size.height *
                  0.5, // نفس ارتفاع الصور الكاملة
            ),
          ),
        ),
      );
    },
  );
}
