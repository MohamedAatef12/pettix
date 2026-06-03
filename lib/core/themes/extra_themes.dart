import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Warm Rose — light theme ────────────────────────────────────────────────────
ThemeData roseLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: GoogleFonts.cairo().fontFamily,
  scaffoldBackgroundColor: const Color(0xffFFF9FC),
  colorScheme: const ColorScheme.light(
    primary: Color(0xffF43F5E),
    secondary: Color(0xff13D586),
    surface: Color(0xffFFF9FC),
    onSurface: Color(0xff1A0812),
    onPrimary: Color(0xFFFFFFFF),
    outline: Color(0xffF2D6E5),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xffFFF9FC),
    foregroundColor: Color(0xff1A0812),
    elevation: 0.5,
    surfaceTintColor: Colors.transparent,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xffFFF9FC),
    surfaceTintColor: Colors.transparent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xffFFF9FC),
    surfaceTintColor: Colors.transparent,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xffFFF9FC),
    surfaceTintColor: Colors.transparent,
  ),
  dividerColor: const Color(0xffF2D6E5),
  cardColor: const Color(0xffFFF9FC),
);

// ── Deep Ocean — dark theme ────────────────────────────────────────────────────
ThemeData oceanDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.cairo().fontFamily,
  scaffoldBackgroundColor: const Color(0xff0A1A2E),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xff06B6D4),
    secondary: Color(0xff4ADE80),
    surface: Color(0xff102340),
    onSurface: Color(0xffE0F0FF),
    onPrimary: Color(0xFFFFFFFF),
    outline: Color(0xff1A3055),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff0A1A2E),
    foregroundColor: Color(0xffE0F0FF),
    elevation: 0.5,
    surfaceTintColor: Colors.transparent,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xff102340),
    surfaceTintColor: Colors.transparent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xff102340),
    surfaceTintColor: Colors.transparent,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xff0A1A2E),
    surfaceTintColor: Colors.transparent,
  ),
  dividerColor: const Color(0xff1A3055),
  cardColor: const Color(0xff102340),
);

// Emerald Garden - light theme
ThemeData emeraldLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: GoogleFonts.cairo().fontFamily,
  scaffoldBackgroundColor: const Color(0xffF7FFFB),
  colorScheme: const ColorScheme.light(
    primary: Color(0xff00A676),
    secondary: Color(0xffFF7A59),
    surface: Color(0xffF7FFFB),
    onSurface: Color(0xff05251A),
    onPrimary: Color(0xFFFFFFFF),
    outline: Color(0xffD5F0E4),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xffF7FFFB),
    foregroundColor: Color(0xff05251A),
    elevation: 0.5,
    surfaceTintColor: Colors.transparent,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xffF7FFFB),
    surfaceTintColor: Colors.transparent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xffF7FFFB),
    surfaceTintColor: Colors.transparent,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xffF7FFFB),
    surfaceTintColor: Colors.transparent,
  ),
  dividerColor: const Color(0xffD5F0E4),
  cardColor: const Color(0xffF7FFFB),
);

// Golden Sunrise - light theme
ThemeData sunriseLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: GoogleFonts.cairo().fontFamily,
  scaffoldBackgroundColor: const Color(0xffFFFBF3),
  colorScheme: const ColorScheme.light(
    primary: Color(0xffF97316),
    secondary: Color(0xff0EA5E9),
    surface: Color(0xffFFFBF3),
    onSurface: Color(0xff261407),
    onPrimary: Color(0xFFFFFFFF),
    outline: Color(0xffF3DDC6),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xffFFFBF3),
    foregroundColor: Color(0xff261407),
    elevation: 0.5,
    surfaceTintColor: Colors.transparent,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xffFFFBF3),
    surfaceTintColor: Colors.transparent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xffFFFBF3),
    surfaceTintColor: Colors.transparent,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xffFFFBF3),
    surfaceTintColor: Colors.transparent,
  ),
  dividerColor: const Color(0xffF3DDC6),
  cardColor: const Color(0xffFFFBF3),
);

// Forest Night - dark theme
ThemeData forestDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.cairo().fontFamily,
  scaffoldBackgroundColor: const Color(0xff071A12),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xff22C55E),
    secondary: Color(0xffF59E0B),
    surface: Color(0xff10261A),
    onSurface: Color(0xffE6FFF0),
    onPrimary: Color(0xff05251A),
    outline: Color(0xff1D3B2A),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff071A12),
    foregroundColor: Color(0xffE6FFF0),
    elevation: 0.5,
    surfaceTintColor: Colors.transparent,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xff10261A),
    surfaceTintColor: Colors.transparent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xff10261A),
    surfaceTintColor: Colors.transparent,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xff071A12),
    surfaceTintColor: Colors.transparent,
  ),
  dividerColor: const Color(0xff1D3B2A),
  cardColor: const Color(0xff10261A),
);

// Ember Glow - dark theme
ThemeData emberDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.cairo().fontFamily,
  scaffoldBackgroundColor: const Color(0xff190D08),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xffF97316),
    secondary: Color(0xffF43F5E),
    surface: Color(0xff26130D),
    onSurface: Color(0xffFFF1E8),
    onPrimary: Color(0xFFFFFFFF),
    outline: Color(0xff3A2118),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff190D08),
    foregroundColor: Color(0xffFFF1E8),
    elevation: 0.5,
    surfaceTintColor: Colors.transparent,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Color(0xff26130D),
    surfaceTintColor: Colors.transparent,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xff26130D),
    surfaceTintColor: Colors.transparent,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xff190D08),
    surfaceTintColor: Colors.transparent,
  ),
  dividerColor: const Color(0xff3A2118),
  cardColor: const Color(0xff26130D),
);

ThemeData _extraTheme({
  required Brightness brightness,
  required Color background,
  required Color surface,
  required Color primary,
  required Color secondary,
  required Color onSurface,
  required Color outline,
  Color onPrimary = Colors.white,
}) {
  final isDark = brightness == Brightness.dark;
  final scheme =
      isDark
          ? ColorScheme.dark(
            primary: primary,
            secondary: secondary,
            surface: surface,
            onSurface: onSurface,
            onPrimary: onPrimary,
            outline: outline,
          )
          : ColorScheme.light(
            primary: primary,
            secondary: secondary,
            surface: background,
            onSurface: onSurface,
            onPrimary: onPrimary,
            outline: outline,
          );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: GoogleFonts.cairo().fontFamily,
    scaffoldBackgroundColor: background,
    colorScheme: scheme,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: onSurface,
      elevation: 0.5,
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
    ),
    dividerColor: outline,
    cardColor: surface,
  );
}

// Lavender Mist - light theme
ThemeData lavenderLightTheme = _extraTheme(
  brightness: Brightness.light,
  background: const Color(0xffFBF8FF),
  surface: const Color(0xffF3EEFF),
  primary: const Color(0xff8B5CF6),
  secondary: const Color(0xff06B6D4),
  onSurface: const Color(0xff1B1230),
  outline: const Color(0xffE1D8F7),
);

// Coral Reef - light theme
ThemeData coralLightTheme = _extraTheme(
  brightness: Brightness.light,
  background: const Color(0xffFFF8F6),
  surface: const Color(0xffFFF0ED),
  primary: const Color(0xffFF5A5F),
  secondary: const Color(0xff00B8A9),
  onSurface: const Color(0xff2D1411),
  outline: const Color(0xffF5D6CF),
);

// Arctic Mint - light theme
ThemeData mintLightTheme = _extraTheme(
  brightness: Brightness.light,
  background: const Color(0xffF5FEFF),
  surface: const Color(0xffE9FBFA),
  primary: const Color(0xff14B8A6),
  secondary: const Color(0xff3B82F6),
  onSurface: const Color(0xff062628),
  outline: const Color(0xffCBEFED),
);

// Graphite Lime - light theme
ThemeData graphiteLightTheme = _extraTheme(
  brightness: Brightness.light,
  background: const Color(0xffF8FAFC),
  surface: const Color(0xffEEF2F6),
  primary: const Color(0xff475569),
  secondary: const Color(0xff84CC16),
  onSurface: const Color(0xff111827),
  outline: const Color(0xffDCE4EC),
);

// Neon Noir - dark theme
ThemeData neonDarkTheme = _extraTheme(
  brightness: Brightness.dark,
  background: const Color(0xff080711),
  surface: const Color(0xff151124),
  primary: const Color(0xffA855F7),
  secondary: const Color(0xff22D3EE),
  onSurface: const Color(0xffF5EDFF),
  outline: const Color(0xff241A3A),
);

// Aurora Dark - dark theme
ThemeData auroraDarkTheme = _extraTheme(
  brightness: Brightness.dark,
  background: const Color(0xff06131F),
  surface: const Color(0xff0C2133),
  primary: const Color(0xff38BDF8),
  secondary: const Color(0xffA3E635),
  onSurface: const Color(0xffEAF8FF),
  outline: const Color(0xff18364D),
  onPrimary: const Color(0xff06131F),
);

// Plum Velvet - dark theme
ThemeData plumDarkTheme = _extraTheme(
  brightness: Brightness.dark,
  background: const Color(0xff1B0B24),
  surface: const Color(0xff2A1234),
  primary: const Color(0xffD946EF),
  secondary: const Color(0xffF59E0B),
  onSurface: const Color(0xffFFEAFE),
  outline: const Color(0xff3C1A4A),
);

// Slate Ruby - dark theme
ThemeData rubyDarkTheme = _extraTheme(
  brightness: Brightness.dark,
  background: const Color(0xff0F1117),
  surface: const Color(0xff1B1D27),
  primary: const Color(0xffFB7185),
  secondary: const Color(0xff60A5FA),
  onSurface: const Color(0xffFFF1F3),
  outline: const Color(0xff2C3040),
);
