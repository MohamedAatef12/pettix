import 'package:flutter/material.dart';

abstract final class ProfileAnimationTokens {
  static const Color screenBackground = Color(0xFFF4F4F8);
  static const Color headerBackground = Color(0xFF171522);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color mutedText = Color(0xFF9A98A6);
  static const Color titleText = Color(0xFF171522);
  static const Color iconBox = Color(0xFFF0F0F3);
  static const Color success = Color(0xFF36D75F);

  static const Duration fast = Duration(milliseconds: 260);
  static const Duration medium = Duration(milliseconds: 420);
  static const Curve curve = Curves.easeInOutCubic;

  static const String savedTitle = 'Profile Saved!';
  static const String savedMessage =
      'Your changes have been saved successfully';
}
