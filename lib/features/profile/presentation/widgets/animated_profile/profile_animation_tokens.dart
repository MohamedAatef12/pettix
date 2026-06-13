import 'package:flutter/material.dart';
import 'package:pettix/core/themes/app_colors.dart';

abstract final class ProfileAnimationTokens {
  static Color get screenBackground => AppColors.current.lightBlue;
  static Color get headerBackground => AppColors.current.primary;
  static Color get cardBackground => AppColors.current.white;
  static Color get mutedText => AppColors.current.lightText;
  static Color get titleText => AppColors.current.text;
  static Color get iconBox => AppColors.current.lightBlue;
  static const Color success = Color(0xFF36D75F);

  static const Duration fast = Duration(milliseconds: 260);
  static const Duration medium = Duration(milliseconds: 420);
  static const Curve curve = Curves.easeInOutCubic;

  static const String savedTitle = 'Profile Saved!';
  static const String savedMessage =
      'Your changes have been saved successfully';
}
