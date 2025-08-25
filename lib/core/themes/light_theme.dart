import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = FlexThemeData.light(
  scheme: FlexScheme.blueM3,
  fontFamily: GoogleFonts.cairo().fontFamily,
  useMaterial3: true,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
  blendLevel: 10,
  appBarElevation: 0.5,
);
