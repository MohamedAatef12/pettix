import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static final String? fontFamily = GoogleFonts.nunito().fontFamily;

  static TextTheme textTheme({required Color textColor}) {
    return GoogleFonts.nunitoTextTheme(
      TextTheme(
        displayLarge: _style(32, FontWeight.w700, textColor),
        displayMedium: _style(28, FontWeight.w700, textColor),
        displaySmall: _style(24, FontWeight.w700, textColor),
        headlineLarge: _style(22, FontWeight.w700, textColor),
        headlineMedium: _style(20, FontWeight.w700, textColor),
        headlineSmall: _style(18, FontWeight.w700, textColor),
        titleLarge: _style(18, FontWeight.w700, textColor),
        titleMedium: _style(16, FontWeight.w600, textColor),
        titleSmall: _style(14, FontWeight.w600, textColor),
        bodyLarge: _style(16, FontWeight.w500, textColor),
        bodyMedium: _style(14, FontWeight.w500, textColor),
        bodySmall: _style(12, FontWeight.w500, textColor),
        labelLarge: _style(14, FontWeight.w700, textColor),
        labelMedium: _style(12, FontWeight.w600, textColor),
        labelSmall: _style(10, FontWeight.w600, textColor),
      ),
    );
  }

  static TextStyle _style(double size, FontWeight weight, Color color) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: 0,
      height: 1.25,
    );
  }
}
