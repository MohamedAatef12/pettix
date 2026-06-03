import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.cairo().fontFamily,
  scaffoldBackgroundColor: const Color(0xff13131F),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xff7C3AED),
    secondary: Color(0xff2DD4BF),
    surface: Color(0xff1E1E2E),
    onSurface: Color(0xffE4E4F5),
    onPrimary: Color(0xFFFFFFFF),
    outline: Color(0xff2A2A3E),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff13131F),
    foregroundColor: Color(0xffE4E4F5),
    elevation: 0.5,
    surfaceTintColor: Colors.transparent,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xff1E1E2E),
    surfaceTintColor: Colors.transparent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xff1E1E2E),
    surfaceTintColor: Colors.transparent,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xff13131F),
    surfaceTintColor: Colors.transparent,
  ),
  dividerColor: const Color(0xff2A2A3E),
  cardColor: const Color(0xff1E1E2E),
);
