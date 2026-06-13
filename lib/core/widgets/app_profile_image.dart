import 'package:pettix/core/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_cached_image.dart';

class AppProfileImage extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double radius;
  final BoxFit fit;
  final Color? backgroundColor;
  final String? heroTag;

  const AppProfileImage({
    super.key,
    required this.imageUrl,
    this.name,
    this.radius = 30,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;

    final image = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? AppColors.current.blueGray,
      ),
      clipBehavior: Clip.antiAlias,
      child: AppCachedImage(
        imageUrl: imageUrl ?? '',
        height: size,
        width: size,
        fit: fit,
        backgroundColor: backgroundColor ?? AppColors.current.blueGray,
        placeholder: AppShimmer.circular(radius: radius),
        errorWidget: _InitialsAvatar(name: name ?? '', size: size),
      ),
    );

    if (heroTag == null) return image;

    return Hero(
      tag: heroTag!,
      createRectTween: (begin, end) {
        return MaterialRectCenterArcTween(begin: begin, end: end);
      },
      flightShuttleBuilder: (
        _,
        __,
        flightDirection,
        fromHeroContext,
        toHeroContext,
      ) {
        final hero =
            (flightDirection == HeroFlightDirection.push
                    ? toHeroContext.widget
                    : fromHeroContext.widget)
                as Hero;

        return Material(
          color: Colors.transparent,
          child: ClipOval(child: hero.child),
        );
      },
      child: image,
    );
  }
}

// ── Initials + paw fallback ───────────────────────────────────────────────────

class _InitialsAvatar extends StatelessWidget {
  final String name;
  final double size;

  const _InitialsAvatar({required this.name, required this.size});

  static const _palette = [
    Color(0xFF5B8FB9), // steel blue
    Color(0xFF7B6BA8), // purple
    Color(0xFF5E9E7A), // teal green
    Color(0xFFD17A5B), // terracotta
    Color(0xFFB87D3A), // amber
    Color(0xFF4A8FA8), // dark cyan
    Color(0xFF6B8A5E), // olive green
    Color(0xFF8B5E7A), // mauve
  ];

  Color get _color {
    if (name.isEmpty) return _palette[0];
    return _palette[name.hashCode.abs() % _palette.length];
  }

  String get _initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    final word = parts[0];
    return word.substring(0, word.length.clamp(1, 2)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: _color,
      child: Center(
        child: Text(
          _initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.34,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            height: 1,
          ),
        ),
      ),
    );
  }
}
