import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/utils/custom_button.dart';

class StepSubmitted extends StatefulWidget {
  final VoidCallback onViewApplication;
  final VoidCallback onBrowseMore;

  const StepSubmitted({
    super.key,
    required this.onViewApplication,
    required this.onBrowseMore,
  });

  @override
  State<StepSubmitted> createState() => _StepSubmittedState();
}

class _StepSubmittedState extends State<StepSubmitted>
    with TickerProviderStateMixin {
  // Wave animation controllers (3 rings expanding outward)
  late final AnimationController _wave1;
  late final AnimationController _wave2;
  late final AnimationController _wave3;

  // Icon scale bounce
  late final AnimationController _bounceCtrl;
  late final Animation<double> _bounceAnim;

  // Confetti
  late final ConfettiController _confettiLeft;
  late final ConfettiController _confettiRight;

  @override
  void initState() {
    super.initState();

    // Wave rings — staggered
    _wave1 = _makeWave(100);
    _wave2 = _makeWave(600);
    _wave3 = _makeWave(900);

    // Bounce in for icon
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 10),
    );
    _bounceAnim = CurvedAnimation(
      parent: _bounceCtrl,
      curve: Curves.elasticOut,
    );
    _bounceCtrl.forward();

    // Confetti
    _confettiLeft = ConfettiController(
      duration: const Duration(seconds: 10),
    );
    _confettiRight = ConfettiController(
      duration: const Duration(seconds: 10),
    );

    // Fire confetti after icon animation completes
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _confettiLeft.play();
        _confettiRight.play();
      }
    });
  }

  AnimationController _makeWave(int delayMs) {
    final ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    Future.delayed(Duration(milliseconds: delayMs), () {
      if (mounted) ctrl.repeat();
    });
    return ctrl;
  }

  @override
  void dispose() {
    _wave1.dispose();
    _wave2.dispose();
    _wave3.dispose();
    _bounceCtrl.dispose();
    _confettiLeft.dispose();
    _confettiRight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.current.primary;

    return Stack(
      children: [
        // ── Confetti Left (top-left corner) ──────────────────────────────
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            confettiController: _confettiLeft,
            blastDirection: -pi / 6, // slight right-downward
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.08,
            numberOfParticles: 18,
            maxBlastForce: 30,
            minBlastForce: 10,
            gravity: 0.3,
            particleDrag: 0.05,
            colors: [
              primaryColor,
              Colors.amber,
              Colors.green,
              Colors.pinkAccent,
              Colors.deepPurple.shade300,
              Colors.orange,
            ],
          ),
        ),

        // ── Confetti Right (top-right corner) ────────────────────────────
        Align(
          alignment: Alignment.topRight,
          child: ConfettiWidget(
            confettiController: _confettiRight,
            blastDirection: pi + pi / 6, // slight left-downward
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.08,
            numberOfParticles: 18,
            maxBlastForce: 30,
            minBlastForce: 10,
            gravity: 0.3,
            particleDrag: 0.05,
            colors: [
              primaryColor,
              Colors.amber,
              Colors.green,
              Colors.pinkAccent,
              Colors.deepPurple.shade300,
              Colors.orange,
            ],
          ),
        ),

        // ── Main Content ─────────────────────────────────────────────────
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Animated Wave Check Icon ────────────────────────────────
              SizedBox(
                width: 160.w,
                height: 160.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Wave ring 3 (outermost)
                    _WaveRing(
                      controller: _wave3,
                      color: primaryColor,
                      maxSize: 600.w,
                    ),
                    // Wave ring 2
                    _WaveRing(
                      controller: _wave2,
                      color: primaryColor,
                      maxSize: 400.w,
                    ),
                    // Wave ring 1 (closest)
                    _WaveRing(
                      controller: _wave1,
                      color: primaryColor,
                      maxSize: 205.w,
                    ),

                    // Bounce-in icon
                    ScaleTransition(
                      scale: _bounceAnim,
                      child: Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.35),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          size: 42.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28.h),

              Text(
                'Application Submitted!',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.current.text,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                'Thank you! The owner will review your application and may contact you via chat.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.current.lightText,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),

              _InfoCard(
                icon: Icons.schedule_rounded,
                iconColor: AppColors.current.gold,
                title: 'What happens next?',
                text:
                    'The pet owner will review your application. If they\'re interested, they\'ll reach out to you through the chat feature.',
              ),

              const Spacer(flex: 3),

              // ── View My Application ────────────────────────────────────
              CustomFilledButton(
                onPressed: widget.onViewApplication,
                text: 'View My Application',
                heightFactor: 0.065,
                backgroundColor: AppColors.current.primary,
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.current.white,
                ),
              ),
              SizedBox(height: 10.h),

              // ── Browse More Pets ────────────────────────────────────────
              GestureDetector(
                onTap: widget.onBrowseMore,
                child: Container(
                  width: double.infinity,
                  height: 50.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.current.lightBlue,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    'Browse More Pets',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.current.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Wave Ring Widget ──────────────────────────────────────────────────────────

class _WaveRing extends StatelessWidget {
  final AnimationController controller;
  final Color color;
  final double maxSize;

  const _WaveRing({
    required this.controller,
    required this.color,
    required this.maxSize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = controller.value;
        final size = maxSize * t;
        final opacity = (1.0 - t).clamp(0.0, 1.0);
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: opacity * 0.25),
          ),
        );
      },
    );
  }
}

// ── Info Card ──────────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String text;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.current.lightBlue,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 18.w, color: iconColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.current.text,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.current.lightText,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
