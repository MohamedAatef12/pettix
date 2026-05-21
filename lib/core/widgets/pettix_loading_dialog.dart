import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/constants/text_styles.dart';

class PettixLoadingDialog extends StatefulWidget {
  final String message;
  const PettixLoadingDialog({super.key, this.message = 'Loading...'});

  @override
  State<PettixLoadingDialog> createState() => _PettixLoadingDialogState();
}

class _PettixLoadingDialogState extends State<PettixLoadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
          decoration: BoxDecoration(
            color: AppColors.current.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Rotating outer ring of dots
                  AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: SizedBox(
                          width: 80.r,
                          height: 80.r,
                          child: Stack(
                            children: List.generate(8, (index) {
                              final double angle = index * math.pi / 4;
                              final double radius = 32.r;
                              final double x = 40.r + radius * math.cos(angle) - 4.r;
                              final double y = 40.r + radius * math.sin(angle) - 4.r;
                              final double opacity = 0.2 + (index / 8.0) * 0.8;
                              return Positioned(
                                left: x,
                                top: y,
                                child: Container(
                                  width: 8.r,
                                  height: 8.r,
                                  decoration: BoxDecoration(
                                    color: AppColors.current.primary.withValues(alpha: opacity),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),
                  // Bouncing/Pulsing center paw icon
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Icon(
                      Icons.pets_rounded,
                      size: 40.r,
                      color: AppColors.current.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: AppTextStyles.bold.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.current.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
