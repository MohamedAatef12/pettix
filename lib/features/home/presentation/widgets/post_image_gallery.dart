import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:pettix/core/widgets/app_cached_image.dart';
import 'package:pettix/core/widgets/rtl_aware_icon.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';

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
                                    child: AppCachedImage(
                                      fit: BoxFit.fill,
                                      imageUrl: images[index],
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
            child: AppCachedImage(
              imageUrl: image,
              height: MediaQuery.of(context).size.height * 0.5,
            ),
          ),
        ),
      );
    },
  );
}

class PostImageGallery extends StatelessWidget {
  const PostImageGallery({super.key, required this.post});

  final PostEntity post;

  @override
  Widget build(BuildContext context) {
    if (post.images.isEmpty) return const SizedBox.shrink();

    final validImages = post.images.where((e) {
      if (e.isEmpty) return false;
      if (e == 'data:image/png;base64,string') {
        debugPrint('⚠️ Filtered out placeholder image: $e');
        return false;
      }
      return e.startsWith('http') || e.startsWith('data:image') || File(e).existsSync();
    }).toList();

    debugPrint('📸 Post ${post.id} has ${post.images.length} images, ${validImages.length} valid');

    if (validImages.isEmpty) return const SizedBox.shrink();

    final imagesToShow = validImages.length > 4 ? validImages.take(4).toList() : validImages;

    if (imagesToShow.length == 2) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: List.generate(2, (index) {
            final image = imagesToShow[index];
            return Expanded(
              child: GestureDetector(
                onTap: () => _openSingleImagePreview(context, image),
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == 0 ? 8.w : 0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.r),
                    child: AppCachedImage(
                      imageUrl: image,
                      height: 200.h,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: GestureDetector(
              onTap: () => _openSingleImagePreview(context, validImages[0]),
              child: AppCachedImage(
                imageUrl: imagesToShow[0],
                height: 300.h,
                heroTag: 'post_image_${post.id}_0',
              ),
            ),
          ),
          if (imagesToShow.length > 1) ...[
            SizedBox(height: 8.h),
            Row(
              children: List.generate(
                imagesToShow.length == 2
                    ? 2
                    : imagesToShow.length > 3
                        ? 3
                        : imagesToShow.length - 1,
                (index) {
                  final actualIndex = index + 1;
                  final image = imagesToShow[actualIndex];
                  final isLastWithMore = actualIndex == 3 && validImages.length > 4;

                  return Expanded(
                    child: SizedBox(
                      height: 100.h,
                      child: GestureDetector(
                        onTap: () {
                          if (isLastWithMore) {
                            _openImagesPreview(context, validImages);
                          } else {
                            _openSingleImagePreview(context, image);
                          }
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child: AppCachedImage(
                                imageUrl: image,
                                height: 100.h,
                                heroTag: 'post_image_${post.id}_$actualIndex',
                              ),
                            ),
                            if (isLastWithMore) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                  child: Container(color: Colors.transparent),
                                ),
                              ),
                              Center(
                                child: Text(
                                  '+${validImages.length - 3}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 6,
                                        color: Colors.black54,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
        ],
      ),
    );
  }
}
