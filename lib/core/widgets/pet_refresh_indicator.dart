import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';

/// Drop-in replacement for [RefreshIndicator] that shows the same
/// paw-ring spinner used on the splash screen.
///
/// The wrapped scrollable must allow overscroll (e.g. use
/// [AlwaysScrollableScrollPhysics] or [BouncingScrollPhysics]).
class PetRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const PetRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<PetRefreshIndicator> createState() => _PetRefreshIndicatorState();
}

class _PetRefreshIndicatorState extends State<PetRefreshIndicator>
    with SingleTickerProviderStateMixin {
  static const double _kTrigger = 58.0;
  static const double _kMaxDrag = 72.0;

  late final AnimationController _spin;

  double _drag = 0;
  bool _refreshing = false;
  bool _pulling = false;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  bool _onNotification(ScrollNotification n) {
    if (_refreshing) return false;

    if (n is ScrollStartNotification && n.metrics.extentBefore == 0.0) {
      // Drag started at the very top — begin tracking
      _pulling = true;
    } else if (n is OverscrollNotification && n.overscroll < 0 && _pulling) {
      // Overscroll delta while pulling down → grow indicator
      _setDrag(_drag + (-n.overscroll));
    } else if (n is ScrollUpdateNotification &&
        n.dragDetails != null &&
        _pulling) {
      final delta = n.scrollDelta ?? 0;
      if (delta > 0 && _drag > 0) {
        // User pushed finger back up → shrink indicator live
        _setDrag(_drag - delta);
      }
    } else if (n is UserScrollNotification &&
        n.direction == ScrollDirection.idle) {
      _pulling = false;
      if (_drag >= _kTrigger) {
        _trigger();
      } else {
        setState(() => _drag = 0);
      }
    }

    return false;
  }

  void _setDrag(double v) {
    setState(() => _drag = v.clamp(0, _kMaxDrag));
  }

  Future<void> _trigger() async {
    setState(() {
      _refreshing = true;
      _drag = _kTrigger;
    });
    await widget.onRefresh();
    if (mounted) {
      setState(() {
        _refreshing = false;
        _drag = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = _refreshing ? _kTrigger : _drag;
    final progress = (_drag / _kTrigger).clamp(0.0, 1.0);
    // Scale circle from 0.3 → 1.0 as user pulls
    final scale = _refreshing ? 1.0 : (0.3 + 0.7 * progress).clamp(0.3, 1.0);

    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: Column(
        children: [
          // Indicator slot — takes real layout space so content is pushed below
          SizedBox(
            height: h,
            child: h > 2
                ? Center(
                    child: Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 46.w,
                        height: 46.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.current.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.10),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: _PawIndicator(
                          spin: _spin,
                          pullProgress: progress,
                          isRefreshing: _refreshing,
                        ),
                      ),
                    ),
                  )
                : null,
          ),

          // Scrollable content — naturally pushed below the indicator
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

// ── Paw spinner ──────────────────────────────────────────────────────────────

class _PawIndicator extends StatelessWidget {
  final AnimationController spin;
  final double pullProgress;
  final bool isRefreshing;

  const _PawIndicator({
    required this.spin,
    required this.pullProgress,
    required this.isRefreshing,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: spin,
      builder: (context, _) {
        final angle = isRefreshing
            ? spin.value * math.pi * 2
            : pullProgress * math.pi * 2;

        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.rotate(
              angle: angle,
              child: CustomPaint(
                size: Size.square(40.w),
                painter: _RingPainter(
                  color: AppColors.current.primary,
                  arcProgress: isRefreshing ? 1.0 : pullProgress.clamp(0.1, 1.0),
                ),
              ),
            ),
            Icon(
              Icons.pets_rounded,
              size: 19.w,
              color: AppColors.current.primary.withValues(alpha: 0.86),
            ),
          ],
        );
      },
    );
  }
}

// ── Ring painter (same as splash _LoadingRingPainter) ─────────────────────────

class _RingPainter extends CustomPainter {
  final Color color;
  final double arcProgress;

  const _RingPainter({required this.color, required this.arcProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final strokeWidth = size.width * 0.08;

    final trackPaint = Paint()
      ..color = color.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final arcPaint = Paint()
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
    canvas.drawArc(
      arcRect,
      -math.pi / 2,
      math.pi * 1.45 * arcProgress,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.color != color || old.arcProgress != arcProgress;
}
