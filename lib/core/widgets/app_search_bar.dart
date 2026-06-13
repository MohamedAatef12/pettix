import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/widgets/app_icon_system.dart';

/// Reusable search bar matching the adoption screen style.
///
/// If [controller] is not supplied, the widget owns its own controller.
/// The clear button appears automatically when the field is non-empty.
class AppSearchBar extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  const AppSearchBar({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _ctrl;
  late final bool _ownsCtrl;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _ownsCtrl = widget.controller == null;
    _ctrl = widget.controller ?? TextEditingController();
    _hasText = _ctrl.text.isNotEmpty;
    _ctrl.addListener(_onText);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onText);
    if (_ownsCtrl) _ctrl.dispose();
    super.dispose();
  }

  void _onText() {
    final has = _ctrl.text.isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  void _clear() {
    _ctrl.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.current.lightGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _ctrl,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        style: TextStyle(color: AppColors.current.text, fontSize: 13.sp),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: AppColors.current.midGray,
            fontSize: 13.sp,
          ),
          prefixIcon: AppIcon.raw(
            Icons.search_rounded,
            color: AppColors.current.midGray,
            size: 18.w,
          ),
          suffixIcon: _hasText
              ? IconButton(
                  icon: AppIcon.raw(
                    Icons.close_rounded,
                    color: AppColors.current.midGray,
                    size: 16.w,
                  ),
                  onPressed: _clear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }
}
