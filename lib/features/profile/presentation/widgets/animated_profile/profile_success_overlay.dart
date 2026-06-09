import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/constants/text_styles.dart';
import 'package:pettix/features/profile/presentation/widgets/animated_profile/profile_animation_tokens.dart';

class ProfileSuccessOverlay extends StatelessWidget {
  final bool isVisible;
  final Color overlayColor;

  const ProfileSuccessOverlay({
    super.key,
    required this.isVisible,
    required this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !isVisible,
        child: AnimatedOpacity(
          opacity: isVisible ? 1 : 0,
          duration: ProfileAnimationTokens.fast,
          child: ColoredBox(
            color: overlayColor,
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.86, end: isVisible ? 1 : 0.86),
                duration: ProfileAnimationTokens.medium,
                curve: Curves.easeOutBack,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 58.w,
                      height: 58.w,
                      decoration: const BoxDecoration(
                        color: ProfileAnimationTokens.success,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, color: Colors.white, size: 34.w),
                    ),
                    SizedBox(height: 22.h),
                    Text(
                      ProfileAnimationTokens.savedTitle,
                      style: AppTextStyles.bold.copyWith(
                        color: Colors.white,
                        fontSize: 22.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      ProfileAnimationTokens.savedMessage,
                      style: AppTextStyles.smallDescription.copyWith(
                        color: Colors.white.withAlpha(205),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
