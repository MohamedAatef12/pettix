import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';

enum _PetToastType { success, error, info }

class PetToast {
  static void showSuccess(
    BuildContext context,
    String message, {
    String? title,
    VoidCallback? onDone,
  }) =>
      _show(context, message, _PetToastType.success, title: title, onDone: onDone);

  static void showError(
    BuildContext context,
    String message, {
    String? title,
  }) =>
      _show(context, message, _PetToastType.error, title: title);

  static void showInfo(
    BuildContext context,
    String message, {
    String? title,
  }) =>
      _show(context, message, _PetToastType.info, title: title);

  static void _show(
    BuildContext context,
    String message,
    _PetToastType type, {
    String? title,
    VoidCallback? onDone,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(ctx).padding.top + 12.h,
        left: 16.w,
        right: 16.w,
        child: Material(
          color: Colors.transparent,
          child: _PetToastWidget(
            message: message,
            type: type,
            title: title,
            onDismiss: () {
              entry.remove();
              onDone?.call();
            },
          ),
        ),
      ),
    );
    overlay.insert(entry);
  }
}

class _PetToastWidget extends StatefulWidget {
  final String message;
  final _PetToastType type;
  final String? title;
  final VoidCallback onDismiss;

  const _PetToastWidget({
    required this.message,
    required this.type,
    required this.onDismiss,
    this.title,
  });

  @override
  State<_PetToastWidget> createState() => _PetToastWidgetState();
}

class _PetToastWidgetState extends State<_PetToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 3300), () {
      if (mounted) {
        _controller
            .animateBack(0, duration: const Duration(milliseconds: 350))
            .then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _config;
    final displayTitle = widget.title ?? cfg.defaultTitle;
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.current.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: cfg.color.withValues(alpha: 0.22),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: cfg.color.withValues(alpha: 0.18),
              width: 1.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 62.w,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      cfg.color.withValues(alpha: 0.14),
                      cfg.color.withValues(alpha: 0.07),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(19.r),
                    bottomLeft: Radius.circular(19.r),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pets, color: cfg.color, size: 22.r),
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.all(2.5.r),
                      decoration: BoxDecoration(
                        color: cfg.color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(cfg.badgeIcon, color: Colors.white, size: 9.r),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayTitle,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: cfg.color,
                          letterSpacing: 0.1,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        widget.message,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.current.lightText,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 14.w),
                child: Icon(
                  Icons.pets,
                  color: cfg.color.withValues(alpha: 0.11),
                  size: 32.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _ToastConfig get _config {
    switch (widget.type) {
      case _PetToastType.success:
        return _ToastConfig(
          color: AppColors.current.green,
          badgeIcon: Icons.check_rounded,
          defaultTitle: 'Done!',
        );
      case _PetToastType.error:
        return _ToastConfig(
          color: AppColors.current.red,
          badgeIcon: Icons.close_rounded,
          defaultTitle: 'Oops!',
        );
      case _PetToastType.info:
        return _ToastConfig(
          color: AppColors.current.gold,
          badgeIcon: Icons.info_rounded,
          defaultTitle: 'Note',
        );
    }
  }
}

class _ToastConfig {
  final Color color;
  final IconData badgeIcon;
  final String defaultTitle;

  const _ToastConfig({
    required this.color,
    required this.badgeIcon,
    required this.defaultTitle,
  });
}
