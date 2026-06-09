import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_logo.dart';
import 'package:pettix/features/splash/persentation/bloc/splash_bloc.dart';
import 'package:pettix/features/splash/persentation/bloc/splash_states.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _loopController;
  bool _met = false;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed && !_met && mounted) {
        setState(() => _met = true);
      }
    });
    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _playEntryAnimation();
      }
    });
  }

  void _playEntryAnimation() {
    setState(() => _met = false);
    _entryController.value = 0;
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        _entryController.forward(from: 0);
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (mounted) {
      _playEntryAnimation();
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _loopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashBloc, SplashState>(
      builder: (context, state) {
        final colors = AppColors.current;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.white, colors.lightBlue, colors.white],
            ),
          ),
          child: Stack(
            children: [
              _FloatingPawBackground(
                animation: _loopController,
                colors: colors,
              ),
              Center(
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _entryController,
                    _loopController,
                  ]),
                  builder: (context, _) {
                    final progress = Curves.easeOutCubic.transform(
                      _entryController.value,
                    );

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _MeetingLogo(colors: colors, progress: progress),
                        SizedBox(height: 18.h),
                        _PawCircleIndicator(
                          animation: _loopController,
                          colors: colors,
                          enabled: _met,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FloatingPawBackground extends StatelessWidget {
  const _FloatingPawBackground({required this.animation, required this.colors});

  final Animation<double> animation;
  final AppColors colors;

  static final List<_PawSeed> _paws = List.generate(18, (index) {
    final random = math.Random(index * 73 + 11);
    return _PawSeed(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: 14 + random.nextDouble() * 22,
      phase: random.nextDouble() * math.pi * 2,
      rotation: -0.8 + random.nextDouble() * 1.6,
      opacity: 0.07 + random.nextDouble() * 0.12,
    );
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children:
                        _paws.map((paw) {
                          final wave = math.sin(
                            animation.value * math.pi * 2 + paw.phase,
                          );
                          final left = paw.x * constraints.maxWidth;
                          final top =
                              paw.y * constraints.maxHeight + wave * 8.h;

                          return Positioned(
                            left: left,
                            top: top,
                            child: Transform.rotate(
                              angle: paw.rotation + wave * 0.12,
                              child: Icon(
                                Icons.pets_rounded,
                                size: paw.size.w,
                                color: colors.primary.withValues(
                                  alpha: paw.opacity + wave.abs() * 0.03,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PawSeed {
  const _PawSeed({
    required this.x,
    required this.y,
    required this.size,
    required this.phase,
    required this.rotation,
    required this.opacity,
  });

  final double x;
  final double y;
  final double size;
  final double phase;
  final double rotation;
  final double opacity;
}

class _MeetingLogo extends StatelessWidget {
  const _MeetingLogo({required this.colors, required this.progress});

  final AppColors colors;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final logoOffset = Offset.lerp(Offset(-520.w, 0), Offset.zero, progress)!;
    final textOffset = Offset.lerp(Offset(420.w, 0), Offset.zero, progress)!;

    return RepaintBoundary(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: logoOffset,
              child: AppLogo(size: 118.w, color: colors.primary),
            ),
            SizedBox(height: 2.h),
            Transform.translate(
              offset: textOffset,
              child: Text(
                'Pettix',
                style: TextStyle(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                  color: colors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PawCircleIndicator extends StatelessWidget {
  const _PawCircleIndicator({
    required this.animation,
    required this.colors,
    required this.enabled,
  });

  final Animation<double> animation;
  final AppColors colors;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: enabled ? 1 : 0,
      child: RepaintBoundary(
        child: SizedBox(
          width: 74.w,
          height: 74.w,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: animation.value * math.pi * 2,
                    child: CustomPaint(
                      size: Size.square(58.w),
                      painter: _LoadingRingPainter(
                        color: colors.primary,
                        progress: animation.value,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.pets_rounded,
                    size: 30.w,
                    color: colors.primary.withValues(alpha: 0.86),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LoadingRingPainter extends CustomPainter {
  const _LoadingRingPainter({required this.color, required this.progress});

  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final strokeWidth = size.width * 0.08;
    final trackPaint =
        Paint()
          ..color = color.withValues(alpha: 0.14)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;
    final arcPaint =
        Paint()
          ..shader = SweepGradient(
            colors: [
              color.withValues(alpha: 0.08),
              color.withValues(alpha: 0.9),
              color.withValues(alpha: 0.22),
            ],
            stops: const [0, 0.55, 1],
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final inset = strokeWidth / 2;
    final arcRect = rect.deflate(inset);
    canvas.drawCircle(size.center(Offset.zero), arcRect.width / 2, trackPaint);
    canvas.drawArc(arcRect, -math.pi / 2, math.pi * 1.45, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _LoadingRingPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.progress != progress;
  }
}
