import 'package:pettix/core/widgets/app_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_top_bar.dart';
import 'package:pettix/features/my_pets/domain/entities/pet_entity.dart';

import 'package:pettix/core/widgets/app_icon_system.dart';

class PetGallery extends StatelessWidget {
  final PetEntity pet;

  const PetGallery({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final urls = pet.imageUrls;

    if (urls.isEmpty) {
      return _placeholder();
    }

    if (urls.length == 1) {
      return _singleImage(context, urls.first);
    }

    return _gridImages(context, urls);
  }

  Widget _singleImage(BuildContext context, String url) {
    return GestureDetector(
      onTap: () => _openFullscreen(context, url),
      child: AppCachedImage(
        imageUrl: url,
        height: 280.h,
        width: double.infinity,
        fit: BoxFit.cover,
        heroTag: 'pet_image_${pet.id}',
        errorWidget: _placeholder(),
      ),
    );
  }

  Widget _gridImages(BuildContext context, List<String> urls) {
    final shown = urls.take(4).toList();
    final extra = urls.length - 4;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(4),
      itemCount: shown.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, i) {
        final isLast = i == 3 && extra > 0;
        return GestureDetector(
          onTap: () => _openFullscreen(context, shown[i]),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: AppCachedImage(
                  imageUrl: shown[i],
                  fit: BoxFit.cover,
                  heroTag: i == 0 ? 'pet_image_${pet.id}' : null,
                  errorWidget: _placeholder(),
                ),
              ),
              if (isLast)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    color: Colors.black54,
                    alignment: Alignment.center,
                    child: Text(
                      '+$extra',
                      style: TextStyle(
                        color: AppColors.current.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _placeholder() => Container(
    height: 280.h,
    color: AppColors.current.lightGray,
    child: AppIcon.raw(
      Icons.pets_rounded,
      size: 64.w,
      color: AppColors.current.blueGray,
    ),
  );

  void _openFullscreen(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppTopBar.back(
                title: '',
                backgroundColor: Colors.transparent,
                backButtonColor: Colors.white,
              ),
              body: Center(
                child: InteractiveViewer(
                  child: AppCachedImage(imageUrl: url, fit: BoxFit.contain),
                ),
              ),
            ),
      ),
    );
  }
}
