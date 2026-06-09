import 'package:pettix/core/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_cached_image.dart';

class AppProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final BoxFit fit;
  final Color? backgroundColor;
  final String? heroTag;

  const AppProfileImage({
    super.key,
    required this.imageUrl,
    this.radius = 30,
    this.fit = BoxFit.cover,
    this.backgroundColor,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = radius;
    final size = effectiveRadius * 2;

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
        errorWidget: Image.asset(
          'assets/images/no_user.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
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
