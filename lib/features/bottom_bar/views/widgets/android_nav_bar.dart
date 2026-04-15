import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pettix/core/constants/radius.dart';
import 'package:pettix/core/themes/app_colors.dart';

/// Modern floating bottom navigation bar for Android.
///
/// Displays 4 navigation tabs with an animated pill indicator,
/// filled/outlined icon crossfade on selection, and a circular
/// add-post button. Floats above the content with rounded corners.
class AndroidNavBar extends StatelessWidget {
  /// Zero-based index of the currently selected tab.
  final int currentIndex;

  /// Called when the user taps a navigation tab.
  final ValueChanged<int> onTabChanged;

  /// Called when the user taps the add-post button.
  final VoidCallback onAddPost;

  const AndroidNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.onAddPost,
  });

  static const _selectedIcons = <IconData>[
    Iconsax.home4,
    Iconsax.pet4,
    // Iconsax.shopping_bag4,
    // Iconsax.hospital4,
  ];

  static const _unselectedIcons = <IconData>[
    Iconsax.home,
    Iconsax.pet,
    // Iconsax.shopping_bag,
    // Iconsax.hospital,
  ];

  static const _labels = ['Home', 'Adopt'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.current.white,
        borderRadius: RadiusConstants.extraLarge,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ...List.generate(
            _labels.length,
            (i) => _AndroidNavItem(
              selectedIcon: _selectedIcons[i],
              unselectedIcon: _unselectedIcons[i],
              label: _labels[i].tr(),
              isSelected: currentIndex == i,
              onTap: () => onTabChanged(i),
            ),
          ),
          _AndroidAddButton(onTap: onAddPost),
        ],
      ),
    );
  }
}

/// Single animated nav item for the Android floating bar.
class _AndroidNavItem extends StatelessWidget {
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AndroidNavItem({
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 12.w : 10.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.current.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: RadiusConstants.large,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Icon(
                  isSelected ? selectedIcon : unselectedIcon,
                  key: ValueKey(isSelected),
                  size: 24.r,
                  color: isSelected
                      ? AppColors.current.primary
                      : AppColors.current.midGray,
                ),
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              child: isSelected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 6.w),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.current.primary,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Circular add-post button with a glow shadow.
class _AndroidAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AndroidAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: AppColors.current.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.current.primary.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Iconsax.add,
          color: AppColors.current.white,
          size: 22.r,
        ),
      ),
    );
  }
}
