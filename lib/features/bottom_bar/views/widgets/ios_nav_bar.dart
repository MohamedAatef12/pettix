import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pettix/core/themes/app_colors.dart';

/// Native-style iOS bottom navigation bar with frosted glass effect.
///
/// Displays 4 navigation tabs with filled/outlined icon crossfade and
/// a circular add-post button anchored to the right side, matching
/// iOS Human Interface Guidelines.
class IosNavBar extends StatelessWidget {
  /// Zero-based index of the currently selected tab.
  final int currentIndex;

  /// Called when the user taps a navigation tab.
  final ValueChanged<int> onTabChanged;

  /// Called when the user taps the add-post button.
  final VoidCallback onAddPost;

  /// Called when the user taps the chat button.
  final VoidCallback? onChatList;

  const IosNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.onAddPost,
    this.onChatList,
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
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.current.white.withValues(alpha: 0.88),
            border: Border(
              top: BorderSide(
                color: AppColors.current.lightGray,
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 52.h,
              child: Row(
                children: [
                  ...List.generate(
                    _labels.length,
                    (i) => Expanded(
                      child: _IosNavItem(
                        selectedIcon: _selectedIcons[i],
                        unselectedIcon: _unselectedIcons[i],
                        label: _labels[i].tr(),
                        isSelected: currentIndex == i,
                        onTap: () => onTabChanged(i),
                      ),
                    ),
                  ),
                  if (currentIndex == 1 && onChatList != null)
                    _IosChatButton(onTap: onChatList!),
                  _IosAddButton(onTap: onAddPost),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Single tab item for the iOS navigation bar.
class _IosNavItem extends StatelessWidget {
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _IosNavItem({
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: isSelected ? 1.12 : 1.0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? selectedIcon : unselectedIcon,
                key: ValueKey(isSelected),
                size: 26.r,
                color: isSelected
                    ? AppColors.current.primary
                    : AppColors.current.midGray,
              ),
            ),
          ),
          SizedBox(height: 3.h),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? AppColors.current.primary
                  : AppColors.current.midGray,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}

/// Circular add-post button anchored to the right of the iOS bar.
class _IosAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _IosAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w, left: 4.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: AppColors.current.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.current.primary.withValues(alpha: 0.30),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Iconsax.add,
            color: AppColors.current.white,
            size: 18.r,
          ),
        ),
      ),
    );
  }
}

/// Circular chat button for the iOS bar.
class _IosChatButton extends StatelessWidget {
  final VoidCallback onTap;

  const _IosChatButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: AppColors.current.blueGray.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Iconsax.messages,
            color: AppColors.current.primary,
            size: 18.r,
          ),
        ),
      ),
    );
  }
}
