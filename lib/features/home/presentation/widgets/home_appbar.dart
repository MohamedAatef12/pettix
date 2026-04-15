import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pettix/config/di/di_wrapper.dart';

import 'package:pettix/core/constants/padding.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/network/constants.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:pettix/features/notification/presentation/bloc/notification_state.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = DI.find<ICacheManager>().getUserData();
    return Padding(
      padding: PaddingConstants.medium,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: CachedNetworkImage(
              imageUrl: user?.avatar ?? '',
              imageBuilder:
                  (context, imageProvider) => ClipOval(
                    child: _buildImage(
                      context,
                      user?.avatar ?? '',
                      height: 54.r,
                      width: 54.r,
                      fit: BoxFit.cover,
                    ),
                  ),
              placeholder:
                  (context, url) => CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.current.lightGray,
                  ),
              errorWidget:
                  (context, url, error) => CircleAvatar(
                    radius: 30.r,
                    backgroundImage: const AssetImage(
                      'assets/images/no_user.png',
                    ),
                  ),
            ),
          ),
          SizedBox(width: 10.w),
          SizedBox(
            width: 120.w,
            child: Text(user!.userName, style: AppTextStyles.bold),
          ),

          Spacer(),
          GestureDetector(
            onTap: () {
              context.push('/home_search');
            },
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColors.current.white,
              child: Icon(Iconsax.search_normal_1, size: 20.r, color: AppColors.current.text),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () {
              context.push('/notifications');
            },
            child: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: AppColors.current.white,
                      child: Icon(Iconsax.notification_bing, size: 20.r, color: AppColors.current.text),
                    ),
                    if (state.totalUnreadCount > 0)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16.w,
                            minHeight: 16.w,
                          ),
                          child: Text(
                            state.totalUnreadCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
Widget _buildImage(
    BuildContext context,
    String image, {
      double? height,
      double? width,
      BoxFit fit = BoxFit.fill,
    }) {
  debugPrint(
    '🖼️ Building image: ${image.substring(0, image.length > 100 ? 100 : image.length)}...',
  );

  if (image.isEmpty) return _errorImage(image, height, width);

  if (image.startsWith('data:image') && image.contains('Resources/')) {
    final filePath = image.split(',').last;
    final properUrl = '${Constants.baseUrl}/$filePath';
    debugPrint('✅ Converted malformed URL to: $properUrl');
    return CachedNetworkImage(
      imageUrl: properUrl,
      height: height,
      width: width ?? double.infinity,
      fit: fit,
      placeholder:
          (context, url) => Container(
        height: height,
        width: width ?? double.infinity,
        color: AppColors.current.lightGray,
      ),
      errorWidget: (context, url, error) {
        debugPrint('❌ Image load error for $properUrl: $error');
        return _errorImage(image, height, width);
      },
    );
  } else if (image.startsWith('http')) {
    String finalUrl = image.trim();
    if (finalUrl.contains('ui-avatars.com')) {
      if (!finalUrl.contains('format=')) {
        finalUrl += finalUrl.contains('?') ? '&format=png' : '?format=png';
      }

      finalUrl = Uri.encodeFull(finalUrl).replaceAll('%20', '+');
    }

    debugPrint('🌐 Final network URL: $finalUrl');

    return CachedNetworkImage(
      imageUrl: finalUrl,
      height: height,
      width: width ?? double.infinity,
      fit: fit,
      placeholder:
          (context, url) => Container(
        height: height,
        width: width ?? double.infinity,
        color: AppColors.current.lightGray,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) {
        debugPrint('❌ Image load error for $finalUrl: $error');
        return _errorImage(image, height, width);
      },
    );
  } else if (image.startsWith('data:image')) {
    try {
      final base64String = image.split(',').last;
      final bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        height: height,
        width: width ?? double.infinity,
        fit: fit,
        errorBuilder: (_, __, ___) => _errorImage(image, height, width),
      );
    } catch (_) {
      return _errorImage(image, height, width);
    }
  } else if (File(image).existsSync()) {
    return Image.file(
      File(image),
      height: height,
      width: width ?? double.infinity,
      fit: fit,
      errorBuilder: (_, __, ___) => _errorImage(image, height, width),
    );
  } else if (image.isNotEmpty) {
    final prefixedUrl =
    image.startsWith('/')
        ? '${Constants.baseUrl}$image'
        : '${Constants.baseUrl}/$image';
    debugPrint('🔗 Attempting to load prefixed URL: $prefixedUrl');
    return CachedNetworkImage(
      imageUrl: prefixedUrl,
      height: height,
      width: width ?? double.infinity,
      fit: fit,
      placeholder:
          (context, url) => Container(
        height: height,
        width: width ?? double.infinity,
        color: AppColors.current.lightGray,
      ),
      errorWidget: (context, url, error) {
        debugPrint('❌ Image load error for $prefixedUrl: $error');
        return _errorImage(image, height, width);
      },
    );
  } else {
    return _errorImage(image, height, width);
  }
}

Widget _errorImage(String image, [double? height, double? width]) {
  final isUser =
      image.toLowerCase().contains('user') ||
          image.toLowerCase().contains('avatar') ||
          image.isEmpty;

  if (isUser) {
    return Image.asset(
      'assets/images/no_user.png',
      height: height,
      width: width ?? double.infinity,
      fit: BoxFit.cover,
    );
  }

  return Container(
    color: AppColors.current.lightGray,
    height: height ?? 200.h,
    width: width ?? double.infinity,
    child: const Icon(Icons.broken_image),
  );
}