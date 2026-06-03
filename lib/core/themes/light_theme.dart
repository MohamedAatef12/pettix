import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: GoogleFonts.cairo().fontFamily,
  scaffoldBackgroundColor: const Color(0xffFAFAFF),
  colorScheme: const ColorScheme.light(
    primary: Color(0xff2563EB),
    secondary: Color(0xff13D586),
    surface: Color(0xffFAFAFF),
    onSurface: Color(0xff030D1B),
    onPrimary: Color(0xFFFFFFFF),
    outline: Color(0xffEBEDF2),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xffFAFAFF),
    foregroundColor: Color(0xff030D1B),
    elevation: 0.5,
    surfaceTintColor: Colors.transparent,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xffFAFAFF),
    surfaceTintColor: Colors.transparent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xffFAFAFF),
    surfaceTintColor: Colors.transparent,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xffFAFAFF),
    surfaceTintColor: Colors.transparent,
  ),
  dividerColor: const Color(0xffEBEDF2),
  cardColor: const Color(0xffFAFAFF),
);
