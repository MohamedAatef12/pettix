import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// A widget that automatically flips icons for RTL languages
class RtlAwareIcon extends StatelessWidget {
  final Widget child;
  final bool shouldFlip;

  const RtlAwareIcon({
    super.key,
    required this.child,
    this.shouldFlip = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!shouldFlip) return child;
    
    final bool isRtl = context.locale.languageCode == 'ar';
    
    if (!isRtl) return child;
    
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scaleByDouble(-1.0, 1.0, 1.0, 1.0),
      child: child,
    );
  }
}
