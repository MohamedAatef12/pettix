import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';
import 'package:pettix/features/home/presentation/widgets/post_card_actions.dart';
import 'package:pettix/features/home/presentation/widgets/post_card_header.dart';
import 'package:pettix/features/home/presentation/widgets/post_image_gallery.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.isDetailView = false,
    this.showOwnerActions = false,
  });

  final PostEntity post;
  final bool isDetailView;
  final bool showOwnerActions;

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
              PostCardHeader(
                post: post,
                isDetailView: isDetailView,
                showOwnerActions: showOwnerActions,
              ),
              Text(post.content, style: AppTextStyles.description),
              PostImageGallery(post: post),
              PostCardActions(post: post, isDetailView: isDetailView),
            ],
          ),
        ),
      ),
    );
  }
}
