import 'package:flutter/material.dart';

class AppColors {
  static AppColors? _current;
  static AppColors get current => _current ?? _defaultLightColors;
  static set current(value) => _current = value;

  AppColors({
    required this.primary,
    required MaterialColor swatch,
    required this.text,
    required this.white,
    required this.green,
    required this.blue,
    required this.red,
    required this.gray,
    required this.yellow,
    required this.teal,
    required this.transparent,
  });
  Color primary;
  Color text;
  Color white;
  Color green;
  Color blue;
  Color red;
  Color gray;
  Color yellow;
  Color teal;
  Color transparent;
}

var _defaultLightColors = AppColors(
  swatch: const MaterialColor(0xffdcebf2, <int, Color>{
    50: Color(0xffdcebf2),
    100: Color(0xffdcebf2),
    200: Color(0xffdcebf2),
    300: Color(0xffdcebf2),
    400: Color(0xffdcebf2),
    500: Color(0xffdcebf2),
    600: Color(0xffdcebf2),
    700: Color(0xffdcebf2),
    800: Color(0xffdcebf2),
    900: Color(0xffdcebf2),
  }),
  primary: const Color(0xffdcebf2),
  blue: const Color(0xff4285F4),
  text: const Color(0xff4D4B4B),
  white: const Color(0xffFFFFFF),
  green: const Color(0xff34A853),
  red: const Color(0xffEA4335),
  gray: const Color(0xffD3DDE9),
  yellow: const Color(0xffF9AB00),
  teal: const Color(0xff13D586),
  transparent: Colors.transparent,
);
