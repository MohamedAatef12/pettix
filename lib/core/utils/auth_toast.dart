import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pettix/core/themes/app_colors.dart';

class AuthToast {
  static void showSuccess(
      BuildContext context,
      String message, {
        VoidCallback? onDone,
      }) {
    _showTopToast(
      context,
      message,
      icon: Icons.check_circle_outline,
      color: AppColors.current.green,
      onDone: onDone,
    );
  }

  static void showError(
      BuildContext context,
      String message,
      ) {
    _showTopToast(
      context,
      message,
      icon: Icons.error_outline,
      color: AppColors.current.red,
    );
  }

  static void _showTopToast(
      BuildContext context,
      String message, {
        required IconData icon,
        required Color color,
        VoidCallback? onDone,
      }) {
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: _AnimatedToast(
            message: message,
            icon: icon,
            color: color,
            onDismiss: () {
              overlayEntry.remove();
              onDone?.call();
            },
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }
}

class _AnimatedToast extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color color;
  final VoidCallback onDismiss;

  const _AnimatedToast({
    required this.message,
    required this.icon,
    required this.color,
    required this.onDismiss,
  });

  @override
  State<_AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<_AnimatedToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slide = Tween(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fade = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      _controller.reverse().then((_) => widget.onDismiss());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.25),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(widget.icon, color: widget.color),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.message,
                      style:  TextStyle(color: AppColors.current.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}