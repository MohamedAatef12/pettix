import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/core/themes/app_colors.dart';

class AppDropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;
  final Color? iconColor;

  const AppDropdownItem({
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
  });
}

/// Theme-safe dropdown that opens a bottom sheet instead of Flutter's
/// native menu (which inherits canvasColor and looks wrong in dark mode).
class AppDropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final IconData? prefixIcon;
  final Color? prefixIconColor;

  const AppDropdown({
    super.key,
    required this.hint,
    required this.items,
    this.value,
    this.onChanged,
    this.prefixIcon,
    this.prefixIconColor,
  });

  /// Opens a standalone picker sheet without needing a full [AppDropdown] widget.
  /// Returns the selected value, or null if dismissed.
  static Future<T?> openSheet<T>(
    BuildContext context, {
    required String hint,
    required List<AppDropdownItem<T>> items,
    T? selected,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (_) => _Sheet<T>(
            hint: hint,
            items: items,
            selected: selected,
            onSelect: (v) => Navigator.of(context).pop(v),
          ),
    );
  }

  void _open(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (_) => _Sheet<T>(
            hint: hint,
            items: items,
            selected: value,
            onSelect: (v) {
              Navigator.of(context).pop();
              onChanged?.call(v);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = items.where((e) => e.value == value).firstOrNull;

    return GestureDetector(
      onTap: () => _open(context),
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          color: AppColors.current.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.current.lightGray),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: [
            if (prefixIcon != null) ...[
              Icon(
                prefixIcon,
                color: prefixIconColor ?? AppColors.current.primary,
                size: 20.w,
              ),
              SizedBox(width: 10.w),
            ],
            Expanded(
              child: Text(
                selected?.label ?? hint,
                style: TextStyle(
                  color:
                      selected != null
                          ? AppColors.current.text
                          : AppColors.current.midGray,
                  fontSize: 14.sp,
                  fontWeight:
                      selected != null ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              Icons.expand_more_rounded,
              color: AppColors.current.midGray,
              size: 22.w,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom-sheet picker ───────────────────────────────────────────────────────

class _Sheet<T> extends StatelessWidget {
  final String hint;
  final List<AppDropdownItem<T>> items;
  final T? selected;
  final ValueChanged<T?> onSelect;

  const _Sheet({
    required this.hint,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
            // ── Handle ───────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.current.lightGray,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
            ),
            // ── Title ────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
              child: Text(
                hint,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.current.text,
                ),
              ),
            ),
            Divider(height: 1, color: AppColors.current.lightGray),
            // ── Scrollable items ─────────────────────────
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                separatorBuilder:
                    (_, __) => Divider(
                      height: 1,
                      indent: 20.w,
                      endIndent: 20.w,
                      color: AppColors.current.lightGray.withValues(alpha: 0.5),
                    ),
                itemBuilder:
                    (_, i) => _Item<T>(
                      item: items[i],
                      selected: selected,
                      onSelect: onSelect,
                    ),
              ),
            ),
            SizedBox(height: 8.h + bottomPadding),
          ],
        ),
      );
  }
}

class _Item<T> extends StatelessWidget {
  final AppDropdownItem<T> item;
  final T? selected;
  final ValueChanged<T?> onSelect;

  const _Item({
    required this.item,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = item.value == selected;
    final accent = item.iconColor ?? AppColors.current.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onSelect(item.value),
        splashColor: AppColors.current.primary.withValues(alpha: 0.06),
        highlightColor: AppColors.current.primary.withValues(alpha: 0.04),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
          child: Row(
            children: [
              if (item.icon != null) ...[
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: accent, size: 18.w),
                ),
                SizedBox(width: 14.w),
              ],
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color:
                        isSelected
                            ? AppColors.current.primary
                            : AppColors.current.text,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.current.primary,
                  size: 20.w,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
