import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/widgets/app_shimmer.dart';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/data/network/constants.dart';

import 'package:pettix/core/widgets/app_icon_system.dart';

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
      return Hero(tag: heroTag!, child: image);
    }
    return image;
  }

  Widget _buildActualImage() {
    final rawUrl = imageUrl.trim();

    // Handle malformed backend values like data:image...,Resources/Pets/x.jpg.
    final backendResourcePath = _extractBackendResourcePath(rawUrl);
    if (backendResourcePath != null) {
      final properUrl = _withApiBaseUrl(backendResourcePath);
      return _buildNetworkImage(properUrl);
    }

    // Handle standard Network URLs
    if (rawUrl.startsWith('http')) {
      String finalUrl = _normalizeHttpUrl(rawUrl);
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
    if (rawUrl.startsWith('data:image')) {
      try {
        final base64String = rawUrl.split(',').last;
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
    if (File(rawUrl).existsSync()) {
      return Image.file(
        File(rawUrl),
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, __, ___) => _buildErrorWidget(),
      );
    }

    // Handle relative paths from backend
    if (rawUrl.isNotEmpty && !rawUrl.startsWith('http')) {
      return _buildNetworkImage(_withApiBaseUrl(rawUrl));
    }

    return _buildErrorWidget();
  }

  String? _extractBackendResourcePath(String url) {
    if (!url.startsWith('data:image')) return null;

    final payload = url.split(',').last.trim().replaceAll('\\', '/');
    final resourcesIndex = payload.indexOf('Resources/');
    if (resourcesIndex == -1) return null;

    return payload.substring(resourcesIndex);
  }

  String _withApiBaseUrl(String path) {
    var normalizedPath = path.trim().replaceAll('\\', '/');
    final resourcesIndex = normalizedPath.indexOf('Resources/');
    if (resourcesIndex > 0) {
      normalizedPath = normalizedPath.substring(resourcesIndex);
    }
    while (normalizedPath.startsWith('/')) {
      normalizedPath = normalizedPath.substring(1);
    }

    final normalizedBaseUrl = Constants.baseUrl.replaceFirst(
      RegExp(r'/+$'),
      '',
    );
    return Uri.encodeFull('$normalizedBaseUrl/$normalizedPath');
  }

  String _normalizeHttpUrl(String url) {
    final normalizedUrl = url.trim().replaceAll('\\', '/');
    return Uri.encodeFull(
      normalizedUrl.replaceFirstMapped(
        RegExp(r'^(https?):/+'),
        (match) => '${match.group(1)}://',
      ),
    );
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
      placeholder:
          (context, url) =>
              placeholder ?? AppShimmer(width: width, height: height),
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
      child:
          errorWidget ??
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmall =
                  constraints.maxHeight < 80 || constraints.maxWidth < 80;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIcon.raw(
                    Icons.image_not_supported_outlined,
                    color: AppColors.current.midGray.withValues(alpha: 0.5),
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
