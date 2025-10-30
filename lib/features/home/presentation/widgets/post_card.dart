import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';
import 'package:pettix/features/home/presentation/pages/comments_page.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            /// --- HEADER (User Info)
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
                    Text(
                      post.author.nameEn.toString(),
                      style: AppTextStyles.bold,
                    ),
                    Text(
                      post.creationDate,
                      style: AppTextStyles.description.copyWith(
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.current.white,
                    child: SvgPicture.asset('assets/icons/more.svg'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            /// --- POST CONTENT
            Text(post.content, style: AppTextStyles.description),
            if (post.images.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Builder(
                  builder: (context) {
                    final validImages =
                        post.images
                            .where(
                              (e) =>
                                  e.isNotEmpty &&
                                  (e.startsWith('http') ||
                                      e.startsWith('data:image') ||
                                      File(e).existsSync()),
                            )
                            .toList();

                    if (validImages.isEmpty) return const SizedBox.shrink();

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: validImages.length == 1 ? 1 : 2,
                        crossAxisSpacing: 8.w,
                        mainAxisSpacing: 8.h,
                        childAspectRatio: 1,
                      ),
                      itemCount: validImages.length,
                      itemBuilder: (context, index) {
                        final image = validImages[index];

                        Widget imageWidget;

                        if (image.startsWith('http')) {
                          imageWidget = Image.network(
                            image,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => Container(
                                  color: AppColors.current.lightGray,
                                  child: const Icon(Icons.broken_image),
                                ),
                          );
                        } else if (image.startsWith('data:image')) {
                          // 🧩 Base64 image
                          try {
                            final base64String = image.split(',').last;
                            final bytes = base64Decode(base64String);
                            imageWidget = Image.memory(
                              bytes,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    color: AppColors.current.lightGray,
                                    child: const Icon(Icons.broken_image),
                                  ),
                            );
                          } catch (_) {
                            imageWidget = Container(
                              color: AppColors.current.lightGray,
                              child: const Icon(Icons.broken_image),
                            );
                          }
                        } else if (File(image).existsSync()) {
                          imageWidget = Image.file(
                            File(image),
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => Container(
                                  color: AppColors.current.lightGray,
                                  child: const Icon(Icons.broken_image),
                                ),
                          );
                        } else {
                          imageWidget = Container(
                            color: AppColors.current.lightGray,
                            child: const Icon(Icons.broken_image),
                          );
                        }

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15.r),
                          child: imageWidget,
                        );
                      },
                    );
                  },
                ),
              )
            else
              const SizedBox.shrink(),

            /// --- ACTION ROW (Like, Comment, Share, Save)
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen:
                  (prev, curr) =>
    prev.likedPostIds != curr.likedPostIds ||
    prev.postLikesCount != curr.postLikesCount ,
              builder: (context, state) {
                final homeBloc = context.read<HomeBloc>();
                final commentsCount = state.postCommentsCount[post.id] ?? 0;
                final isLiked = state.likedPostIds.contains(post.id);
                final likesCount =
                    state.postLikesCount[post.id] ?? post.likes.length;

                return Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (isLiked) {
                          homeBloc.add(DeleteLikeEvent(post.id));
                        } else {
                          homeBloc.add(AddLikeEvent(post.id));
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

                    /// 💬 COMMENT BUTTON
                    GestureDetector(
                      onTap: () {
                        debugPrint('🔵 Adding GetPostCommentsCountsEvent for post ${post.id}');
                        context.read<HomeBloc>().add(GetPostCommentsCountsEvent(post.id));
                        CommentsBottomSheet.show(context, post.id);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/comment.svg',
                        height: 22.h,
                        width: 22.w,
                      ),
                    ),
                    SizedBox(width: 4.w),

                    Text(
                      (commentsCount).toString(),
                      style: AppTextStyles.description,
                    ),



                    const Spacer(),

                    /// 📤 SHARE BUTTON
                    GestureDetector(
                      onTap: () {
                        // final link = 'http://alefak.runasp.net/posts/${post.id}';
                        // Share.shareUri(Uri.parse(link));
                      },
                      child: SvgPicture.asset('assets/icons/share.svg'),
                    ),
                    SizedBox(width: 10.w),

                    /// 💾 SAVE BUTTON
                    GestureDetector(
                      onTap: () {
                        context.push('/chat_list');
                      },
                      child: SvgPicture.asset('assets/icons/save_post.svg'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
