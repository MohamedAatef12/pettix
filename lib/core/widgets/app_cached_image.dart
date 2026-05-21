import 'package:pettix/core/widgets/app_shimmer.dart';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/data/network/constants.dart';

class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? backgroundColor;

  final String? heroTag;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (imageUrl.isEmpty || imageUrl == 'null') {
      image = _buildErrorWidget();
    } else {
      image = _buildActualImage();
    }

    if (heroTag != null) {
      return Hero(
        tag: heroTag!,
        child: image,
      );
    }
    return image;
  }

  Widget _buildActualImage() {

    // Handle malformed Railway URLs
    if (imageUrl.startsWith('data:image') && imageUrl.contains('Resources/')) {
      final filePath = imageUrl.split(',').last;
      final properUrl = '${Constants.baseUrl}/$filePath';
      return _buildNetworkImage(properUrl);
    }

    // Handle standard Network URLs
    if (imageUrl.startsWith('http')) {
      String finalUrl = imageUrl.trim();
      // Handle UI Avatars specific format
      if (finalUrl.contains('ui-avatars.com')) {
        if (!finalUrl.contains('format=')) {
          finalUrl += finalUrl.contains('?') ? '&format=png' : '?format=png';
        }
        finalUrl = Uri.encodeFull(finalUrl).replaceAll('%20', '+');
      }
      return _buildNetworkImage(finalUrl);
    }

    // Handle Base64 images
    if (imageUrl.startsWith('data:image')) {
      try {
        final base64String = imageUrl.split(',').last;
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (_, __, ___) => _buildErrorWidget(),
        );
      } catch (_) {
        return _buildErrorWidget();
      }
    }

    // Handle Local File paths
    if (File(imageUrl).existsSync()) {
      return Image.file(
        File(imageUrl),
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildErrorWidget(),
      );
    }

    // Handle relative paths from backend
    if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      String path = imageUrl.replaceAll('\\', '/');
      while (path.startsWith('/')) {
        path = path.substring(1);
      }
      final prefixedUrl = '${Constants.baseUrl}/$path';
      return _buildNetworkImage(prefixedUrl);
    }

    return _buildErrorWidget();
  }

  Widget _buildNetworkImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      httpHeaders: const {
        'ngrok-skip-browser-warning': 'true',
        'User-Agent': 'Mozilla/5.0',
      },
      placeholder: (context, url) =>
          placeholder ??
          AppShimmer(
            width: width,
            height: height,
          ),
      errorWidget: (context, url, error) {
        debugPrint('❌ AppCachedImage error for $url: $error');
        return errorWidget ?? _buildErrorWidget();
      },
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: backgroundColor ?? AppColors.current.lightBlue,
      height: height,
      width: width,
      alignment: Alignment.center,
      child: errorWidget ?? LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxHeight < 80 || constraints.maxWidth < 80;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.current.midGray.withOpacity(0.5),
                size: isSmall ? 20.r : 32.r,
              ),
              if (!isSmall) ...[
                SizedBox(height: 8.h),
                Text(
                  'Image unavailable',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.current.midGray,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
