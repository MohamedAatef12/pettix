import 'package:flutter/material.dart';

class AppColors {
  static AppColors? _current;
  static AppColors get current => _current ?? _defaultLightColors;
  static set current(value) => _current = value;

  AppColors({
    required this.primary,
    required this.lightBlue,
    required this.lightGray,
    required this.midGray,
    required this.gray,
    required this.white,
    required this.text,
    required this.lightText,
    required this.green,
    required this.red,
    required this.yellow,
    required this.lightYellow,
    required this.teal,
    required this.transparent,
    required this.blueGray,
    required MaterialColor swatch,
  });
  Color primary;
  Color lightBlue;
  Color lightGray;
  Color midGray;
  Color gray;
  Color white;
  Color text;
  Color lightText;
  Color green;
  Color red;
  Color yellow;
  Color lightYellow;
  Color teal;
  Color transparent;
  Color blueGray;
}

var _defaultLightColors = AppColors(
  swatch: const MaterialColor(0xff5379B2, <int, Color>{
    50: Color(0xff5379B2),
    100: Color(0xff5379B2),
    200: Color(0xff5379B2),
    300: Color(0xff5379B2),
    400: Color(0xff5379B2),
    500: Color(0xff5379B2),
    600: Color(0xff5379B2),
    700: Color(0xff5379B2),
    800: Color(0xff5379B2),
    900: Color(0xff5379B2),
  }),
  primary: const Color(0xff5379B2),
  lightBlue: const Color(0xffF0F2F8),
  lightGray: const Color(0xffEBEDF2),
  midGray: const Color(0xff9392A3),
  gray: const Color(0xff626568),
  white: const Color(0xffFAFAFF),
  text: const Color(0xff030D1B),
  lightText: const Color(0xff868594),
  green: const Color(0xff34A853),
  red: const Color(0xffEA4335),
  yellow: const Color(0xffF9AB00),
  lightYellow: const Color(0xffF7F3ED),
  teal: const Color(0xff13D586),
  transparent: Colors.transparent,
  blueGray: const Color(0xffC0CCDD)
);
