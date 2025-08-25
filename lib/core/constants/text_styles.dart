import 'package:flutter/material.dart';
import 'package:pettix/core/themes/app_colors.dart';

class TextStyles {
  // Regular Text Styles
  static TextStyle small = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.current.text,
  );
  static TextStyle medium = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.current.text,
  );
  static TextStyle large = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.normal,
    color: AppColors.current.text,
  );
  static TextStyle extraLarge = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.normal,
    color: AppColors.current.text,
  );

  // Bold Text Styles
  static TextStyle smallBold = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    color: AppColors.current.text,
  );
  static TextStyle mediumBold = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.current.text,
  );
  static TextStyle largeBold = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.current.text,
  );
  static TextStyle extraLargeBold = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppColors.current.text,
  );

  // Italic Text Styles
  static TextStyle smallItalic = TextStyle(
    fontSize: 12.0,
    fontStyle: FontStyle.italic,
    color: AppColors.current.text,
  );
  static TextStyle mediumItalic = TextStyle(
    fontSize: 16.0,
    fontStyle: FontStyle.italic,
    color: AppColors.current.text,
  );
  static TextStyle largeItalic = TextStyle(
    fontSize: 20.0,
    fontStyle: FontStyle.italic,
    color: AppColors.current.text,
  );
  static TextStyle extraLargeItalic = TextStyle(
    fontSize: 24.0,
    fontStyle: FontStyle.italic,
    color: AppColors.current.text,
  );

  // Customizable Text Styles
  static TextStyle custom({
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    Color color = Colors.black,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
    );
  }
}
