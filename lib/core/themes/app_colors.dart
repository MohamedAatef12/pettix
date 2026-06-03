import 'package:flutter/material.dart';

class AppColors {
  static AppColors? _current;
  static AppColors get current => _current ?? _defaultLightColors;
  static set current(AppColors value) => _current = value;

  static AppColors get light => _defaultLightColors;
  static AppColors get dark => _defaultDarkColors;
  static AppColors get roseLight => _roseLightColors;
  static AppColors get oceanDark => _oceanDarkColors;
  static AppColors get emeraldLight => _emeraldLightColors;
  static AppColors get sunriseLight => _sunriseLightColors;
  static AppColors get forestDark => _forestDarkColors;
  static AppColors get emberDark => _emberDarkColors;
  static AppColors get lavenderLight => _lavenderLightColors;
  static AppColors get coralLight => _coralLightColors;
  static AppColors get mintLight => _mintLightColors;
  static AppColors get graphiteLight => _graphiteLightColors;
  static AppColors get neonDark => _neonDarkColors;
  static AppColors get auroraDark => _auroraDarkColors;
  static AppColors get plumDark => _plumDarkColors;
  static AppColors get rubyDark => _rubyDarkColors;

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
    required this.brown,
    required this.gold,
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
  Color brown;
  Color gold;
}

// ── Warm Rose — light palette ─────────────────────────────────────────────────
var _roseLightColors = AppColors(
  swatch: const MaterialColor(0xffF43F5E, <int, Color>{
    50: Color(0xffF43F5E),
    100: Color(0xffF43F5E),
    200: Color(0xffF43F5E),
    300: Color(0xffF43F5E),
    400: Color(0xffF43F5E),
    500: Color(0xffF43F5E),
    600: Color(0xffF43F5E),
    700: Color(0xffF43F5E),
    800: Color(0xffF43F5E),
    900: Color(0xffF43F5E),
  }),
  primary: const Color(0xffF43F5E), // vibrant magenta-rose
  lightBlue: const Color(0xffFFF0F6), // card / input surface
  lightGray: const Color(0xffF2D6E5), // border / divider
  midGray: const Color(0xffA08494), // placeholder text
  gray: const Color(0xff7A6272), // secondary text
  white: const Color(0xffFFF9FC), // main background
  text: const Color(0xff1A0812), // primary text
  lightText: const Color(0xff8B7080), // secondary text
  green: const Color(0xff34A853),
  red: const Color(0xffEA4335),
  yellow: const Color(0xffF9AB00),
  lightYellow: const Color(0xffFFF8EC),
  teal: const Color(0xff13D586),
  transparent: Colors.transparent,
  blueGray: const Color(0xffD4A8C0),
  brown: const Color(0xffE8D0C0),
  gold: const Color(0xffC8933D),
);

// ── Deep Ocean — dark palette ──────────────────────────────────────────────────
var _oceanDarkColors = AppColors(
  swatch: const MaterialColor(0xff06B6D4, <int, Color>{
    50: Color(0xff06B6D4),
    100: Color(0xff06B6D4),
    200: Color(0xff06B6D4),
    300: Color(0xff06B6D4),
    400: Color(0xff06B6D4),
    500: Color(0xff06B6D4),
    600: Color(0xff06B6D4),
    700: Color(0xff06B6D4),
    800: Color(0xff06B6D4),
    900: Color(0xff06B6D4),
  }),
  primary: const Color(0xff06B6D4), // vivid cyan
  lightBlue: const Color(0xff102340), // deep card surface
  lightGray: const Color(0xff1A3055), // border / divider
  midGray: const Color(0xff4A7A9B), // muted text
  gray: const Color(0xff7AAAC0), // secondary text
  white: const Color(0xff0A1A2E), // main background (deep ocean)
  text: const Color(0xffE0F0FF), // primary text
  lightText: const Color(0xff7AAAC0), // secondary text
  green: const Color(0xff4ADE80),
  red: const Color(0xffF87171),
  yellow: const Color(0xffFCD34D),
  lightYellow: const Color(0xff1A2010),
  teal: const Color(0xff06B6D4),
  transparent: Colors.transparent,
  blueGray: const Color(0xff2A4A6A),
  brown: const Color(0xff1A2A3A),
  gold: const Color(0xffF59E0B),
);

// Emerald Garden - light palette
var _emeraldLightColors = AppColors(
  swatch: const MaterialColor(0xff00A676, <int, Color>{
    50: Color(0xff00A676),
    100: Color(0xff00A676),
    200: Color(0xff00A676),
    300: Color(0xff00A676),
    400: Color(0xff00A676),
    500: Color(0xff00A676),
    600: Color(0xff00A676),
    700: Color(0xff00A676),
    800: Color(0xff00A676),
    900: Color(0xff00A676),
  }),
  primary: const Color(0xff00A676),
  lightBlue: const Color(0xffEFFFF7),
  lightGray: const Color(0xffD5F0E4),
  midGray: const Color(0xff729487),
  gray: const Color(0xff506C62),
  white: const Color(0xffF7FFFB),
  text: const Color(0xff05251A),
  lightText: const Color(0xff6E8F82),
  green: const Color(0xff16A34A),
  red: const Color(0xffDC2626),
  yellow: const Color(0xffF59E0B),
  lightYellow: const Color(0xffFFF6E7),
  teal: const Color(0xffFF7A59),
  transparent: Colors.transparent,
  blueGray: const Color(0xffBBD8CD),
  brown: const Color(0xffEAD8C5),
  gold: const Color(0xffD9911F),
);

// Golden Sunrise - light palette
var _sunriseLightColors = AppColors(
  swatch: const MaterialColor(0xffF97316, <int, Color>{
    50: Color(0xffF97316),
    100: Color(0xffF97316),
    200: Color(0xffF97316),
    300: Color(0xffF97316),
    400: Color(0xffF97316),
    500: Color(0xffF97316),
    600: Color(0xffF97316),
    700: Color(0xffF97316),
    800: Color(0xffF97316),
    900: Color(0xffF97316),
  }),
  primary: const Color(0xffF97316),
  lightBlue: const Color(0xffFFF3E7),
  lightGray: const Color(0xffF3DDC6),
  midGray: const Color(0xff9B7B5D),
  gray: const Color(0xff70573E),
  white: const Color(0xffFFFBF3),
  text: const Color(0xff261407),
  lightText: const Color(0xff8A6C52),
  green: const Color(0xff22C55E),
  red: const Color(0xffEF4444),
  yellow: const Color(0xffEAB308),
  lightYellow: const Color(0xffFFF8DF),
  teal: const Color(0xff0EA5E9),
  transparent: Colors.transparent,
  blueGray: const Color(0xffC2D7E8),
  brown: const Color(0xffE8C7A7),
  gold: const Color(0xffD99A18),
);

// Forest Night - dark palette
var _forestDarkColors = AppColors(
  swatch: const MaterialColor(0xff22C55E, <int, Color>{
    50: Color(0xff22C55E),
    100: Color(0xff22C55E),
    200: Color(0xff22C55E),
    300: Color(0xff22C55E),
    400: Color(0xff22C55E),
    500: Color(0xff22C55E),
    600: Color(0xff22C55E),
    700: Color(0xff22C55E),
    800: Color(0xff22C55E),
    900: Color(0xff22C55E),
  }),
  primary: const Color(0xff22C55E),
  lightBlue: const Color(0xff10261A),
  lightGray: const Color(0xff1D3B2A),
  midGray: const Color(0xff5B806C),
  gray: const Color(0xff89B49C),
  white: const Color(0xff071A12),
  text: const Color(0xffE6FFF0),
  lightText: const Color(0xff8CBDA2),
  green: const Color(0xff4ADE80),
  red: const Color(0xffFB7185),
  yellow: const Color(0xffF59E0B),
  lightYellow: const Color(0xff241E0C),
  teal: const Color(0xffF59E0B),
  transparent: Colors.transparent,
  blueGray: const Color(0xff244733),
  brown: const Color(0xff2E2516),
  gold: const Color(0xffFBBF24),
);

// Ember Glow - dark palette
var _emberDarkColors = AppColors(
  swatch: const MaterialColor(0xffF97316, <int, Color>{
    50: Color(0xffF97316),
    100: Color(0xffF97316),
    200: Color(0xffF97316),
    300: Color(0xffF97316),
    400: Color(0xffF97316),
    500: Color(0xffF97316),
    600: Color(0xffF97316),
    700: Color(0xffF97316),
    800: Color(0xffF97316),
    900: Color(0xffF97316),
  }),
  primary: const Color(0xffF97316),
  lightBlue: const Color(0xff26130D),
  lightGray: const Color(0xff3A2118),
  midGray: const Color(0xff916E60),
  gray: const Color(0xffD3A18E),
  white: const Color(0xff190D08),
  text: const Color(0xffFFF1E8),
  lightText: const Color(0xffD2A18D),
  green: const Color(0xff34D399),
  red: const Color(0xffFB7185),
  yellow: const Color(0xffFBBF24),
  lightYellow: const Color(0xff2C210E),
  teal: const Color(0xffF43F5E),
  transparent: Colors.transparent,
  blueGray: const Color(0xff4A2C25),
  brown: const Color(0xff3A2118),
  gold: const Color(0xffF59E0B),
);

// Lavender Mist - light palette
var _lavenderLightColors = AppColors(
  swatch: const MaterialColor(0xff8B5CF6, <int, Color>{
    50: Color(0xff8B5CF6),
    100: Color(0xff8B5CF6),
    200: Color(0xff8B5CF6),
    300: Color(0xff8B5CF6),
    400: Color(0xff8B5CF6),
    500: Color(0xff8B5CF6),
    600: Color(0xff8B5CF6),
    700: Color(0xff8B5CF6),
    800: Color(0xff8B5CF6),
    900: Color(0xff8B5CF6),
  }),
  primary: const Color(0xff8B5CF6),
  lightBlue: const Color(0xffF3EEFF),
  lightGray: const Color(0xffE1D8F7),
  midGray: const Color(0xff81739F),
  gray: const Color(0xff5F5475),
  white: const Color(0xffFBF8FF),
  text: const Color(0xff1B1230),
  lightText: const Color(0xff83749D),
  green: const Color(0xff22C55E),
  red: const Color(0xffEF4444),
  yellow: const Color(0xffF59E0B),
  lightYellow: const Color(0xffFFF7E6),
  teal: const Color(0xff06B6D4),
  transparent: Colors.transparent,
  blueGray: const Color(0xffC9C2DE),
  brown: const Color(0xffE4D2C8),
  gold: const Color(0xffD29A25),
);

// Coral Reef - light palette
var _coralLightColors = AppColors(
  swatch: const MaterialColor(0xffFF5A5F, <int, Color>{
    50: Color(0xffFF5A5F),
    100: Color(0xffFF5A5F),
    200: Color(0xffFF5A5F),
    300: Color(0xffFF5A5F),
    400: Color(0xffFF5A5F),
    500: Color(0xffFF5A5F),
    600: Color(0xffFF5A5F),
    700: Color(0xffFF5A5F),
    800: Color(0xffFF5A5F),
    900: Color(0xffFF5A5F),
  }),
  primary: const Color(0xffFF5A5F),
  lightBlue: const Color(0xffFFF0ED),
  lightGray: const Color(0xffF5D6CF),
  midGray: const Color(0xffA47A72),
  gray: const Color(0xff795A54),
  white: const Color(0xffFFF8F6),
  text: const Color(0xff2D1411),
  lightText: const Color(0xff927169),
  green: const Color(0xff16A34A),
  red: const Color(0xffE11D48),
  yellow: const Color(0xffF59E0B),
  lightYellow: const Color(0xffFFF7E8),
  teal: const Color(0xff00B8A9),
  transparent: Colors.transparent,
  blueGray: const Color(0xffBADDD9),
  brown: const Color(0xffE7C6B9),
  gold: const Color(0xffC78922),
);

// Arctic Mint - light palette
var _mintLightColors = AppColors(
  swatch: const MaterialColor(0xff14B8A6, <int, Color>{
    50: Color(0xff14B8A6),
    100: Color(0xff14B8A6),
    200: Color(0xff14B8A6),
    300: Color(0xff14B8A6),
    400: Color(0xff14B8A6),
    500: Color(0xff14B8A6),
    600: Color(0xff14B8A6),
    700: Color(0xff14B8A6),
    800: Color(0xff14B8A6),
    900: Color(0xff14B8A6),
  }),
  primary: const Color(0xff14B8A6),
  lightBlue: const Color(0xffE9FBFA),
  lightGray: const Color(0xffCBEFED),
  midGray: const Color(0xff65908D),
  gray: const Color(0xff4A6B70),
  white: const Color(0xffF5FEFF),
  text: const Color(0xff062628),
  lightText: const Color(0xff668C90),
  green: const Color(0xff22C55E),
  red: const Color(0xffEF4444),
  yellow: const Color(0xffEAB308),
  lightYellow: const Color(0xffFFF9DB),
  teal: const Color(0xff3B82F6),
  transparent: Colors.transparent,
  blueGray: const Color(0xffB9D4E4),
  brown: const Color(0xffD7CCC1),
  gold: const Color(0xffD69B1E),
);

// Graphite Lime - light palette
var _graphiteLightColors = AppColors(
  swatch: const MaterialColor(0xff475569, <int, Color>{
    50: Color(0xff475569),
    100: Color(0xff475569),
    200: Color(0xff475569),
    300: Color(0xff475569),
    400: Color(0xff475569),
    500: Color(0xff475569),
    600: Color(0xff475569),
    700: Color(0xff475569),
    800: Color(0xff475569),
    900: Color(0xff475569),
  }),
  primary: const Color(0xff475569),
  lightBlue: const Color(0xffEEF2F6),
  lightGray: const Color(0xffDCE4EC),
  midGray: const Color(0xff7B8795),
  gray: const Color(0xff5F6B7A),
  white: const Color(0xffF8FAFC),
  text: const Color(0xff111827),
  lightText: const Color(0xff768395),
  green: const Color(0xff65A30D),
  red: const Color(0xffDC2626),
  yellow: const Color(0xffCA8A04),
  lightYellow: const Color(0xffF7FCEB),
  teal: const Color(0xff84CC16),
  transparent: Colors.transparent,
  blueGray: const Color(0xffCBD5E1),
  brown: const Color(0xffD8CAB6),
  gold: const Color(0xffB98918),
);

// Neon Noir - dark palette
var _neonDarkColors = AppColors(
  swatch: const MaterialColor(0xffA855F7, <int, Color>{
    50: Color(0xffA855F7),
    100: Color(0xffA855F7),
    200: Color(0xffA855F7),
    300: Color(0xffA855F7),
    400: Color(0xffA855F7),
    500: Color(0xffA855F7),
    600: Color(0xffA855F7),
    700: Color(0xffA855F7),
    800: Color(0xffA855F7),
    900: Color(0xffA855F7),
  }),
  primary: const Color(0xffA855F7),
  lightBlue: const Color(0xff151124),
  lightGray: const Color(0xff241A3A),
  midGray: const Color(0xff776497),
  gray: const Color(0xffB5A6CF),
  white: const Color(0xff080711),
  text: const Color(0xffF5EDFF),
  lightText: const Color(0xffB6A7CF),
  green: const Color(0xff34D399),
  red: const Color(0xffFB7185),
  yellow: const Color(0xffFACC15),
  lightYellow: const Color(0xff251E08),
  teal: const Color(0xff22D3EE),
  transparent: Colors.transparent,
  blueGray: const Color(0xff2A2340),
  brown: const Color(0xff2D1D20),
  gold: const Color(0xffF59E0B),
);

// Aurora Dark - dark palette
var _auroraDarkColors = AppColors(
  swatch: const MaterialColor(0xff38BDF8, <int, Color>{
    50: Color(0xff38BDF8),
    100: Color(0xff38BDF8),
    200: Color(0xff38BDF8),
    300: Color(0xff38BDF8),
    400: Color(0xff38BDF8),
    500: Color(0xff38BDF8),
    600: Color(0xff38BDF8),
    700: Color(0xff38BDF8),
    800: Color(0xff38BDF8),
    900: Color(0xff38BDF8),
  }),
  primary: const Color(0xff38BDF8),
  lightBlue: const Color(0xff0C2133),
  lightGray: const Color(0xff18364D),
  midGray: const Color(0xff5F88A5),
  gray: const Color(0xffA4C7DA),
  white: const Color(0xff06131F),
  text: const Color(0xffEAF8FF),
  lightText: const Color(0xff9EC4D8),
  green: const Color(0xffA3E635),
  red: const Color(0xffFB7185),
  yellow: const Color(0xffFDE047),
  lightYellow: const Color(0xff1D2508),
  teal: const Color(0xffA3E635),
  transparent: Colors.transparent,
  blueGray: const Color(0xff1B3B55),
  brown: const Color(0xff26311B),
  gold: const Color(0xffFACC15),
);

// Plum Velvet - dark palette
var _plumDarkColors = AppColors(
  swatch: const MaterialColor(0xffD946EF, <int, Color>{
    50: Color(0xffD946EF),
    100: Color(0xffD946EF),
    200: Color(0xffD946EF),
    300: Color(0xffD946EF),
    400: Color(0xffD946EF),
    500: Color(0xffD946EF),
    600: Color(0xffD946EF),
    700: Color(0xffD946EF),
    800: Color(0xffD946EF),
    900: Color(0xffD946EF),
  }),
  primary: const Color(0xffD946EF),
  lightBlue: const Color(0xff2A1234),
  lightGray: const Color(0xff3C1A4A),
  midGray: const Color(0xff9364A4),
  gray: const Color(0xffD3A5E1),
  white: const Color(0xff1B0B24),
  text: const Color(0xffFFEAFE),
  lightText: const Color(0xffCFA6DB),
  green: const Color(0xff4ADE80),
  red: const Color(0xffFB7185),
  yellow: const Color(0xffF59E0B),
  lightYellow: const Color(0xff2A1B08),
  teal: const Color(0xffF59E0B),
  transparent: Colors.transparent,
  blueGray: const Color(0xff44214F),
  brown: const Color(0xff3A211E),
  gold: const Color(0xffFBBF24),
);

// Slate Ruby - dark palette
var _rubyDarkColors = AppColors(
  swatch: const MaterialColor(0xffFB7185, <int, Color>{
    50: Color(0xffFB7185),
    100: Color(0xffFB7185),
    200: Color(0xffFB7185),
    300: Color(0xffFB7185),
    400: Color(0xffFB7185),
    500: Color(0xffFB7185),
    600: Color(0xffFB7185),
    700: Color(0xffFB7185),
    800: Color(0xffFB7185),
    900: Color(0xffFB7185),
  }),
  primary: const Color(0xffFB7185),
  lightBlue: const Color(0xff1B1D27),
  lightGray: const Color(0xff2C3040),
  midGray: const Color(0xff747B91),
  gray: const Color(0xffB7BECE),
  white: const Color(0xff0F1117),
  text: const Color(0xffFFF1F3),
  lightText: const Color(0xffB8BECD),
  green: const Color(0xff34D399),
  red: const Color(0xffF43F5E),
  yellow: const Color(0xffFBBF24),
  lightYellow: const Color(0xff261F0E),
  teal: const Color(0xff60A5FA),
  transparent: Colors.transparent,
  blueGray: const Color(0xff303747),
  brown: const Color(0xff30221F),
  gold: const Color(0xffF59E0B),
);

// ── Midnight Indigo — dark palette ────────────────────────────────────────────
var _defaultDarkColors = AppColors(
  swatch: const MaterialColor(0xff7C3AED, <int, Color>{
    50: Color(0xff7C3AED),
    100: Color(0xff7C3AED),
    200: Color(0xff7C3AED),
    300: Color(0xff7C3AED),
    400: Color(0xff7C3AED),
    500: Color(0xff7C3AED),
    600: Color(0xff7C3AED),
    700: Color(0xff7C3AED),
    800: Color(0xff7C3AED),
    900: Color(0xff7C3AED),
  }),
  primary: const Color(0xff7C3AED), // vibrant indigo-violet
  lightBlue: const Color(0xff1E1E2E), // deep surface (input bg, card bg)
  lightGray: const Color(0xff2A2A3E), // border / divider
  midGray: const Color(0xff6B6B85), // muted / placeholder text
  gray: const Color(0xff9090AA), // secondary text
  white: const Color(0xff13131F), // main background
  text: const Color(0xffE4E4F5), // primary text
  lightText: const Color(0xff8080A0), // secondary text
  green: const Color(0xff4ADE80),
  red: const Color(0xffF87171),
  yellow: const Color(0xffFCD34D),
  lightYellow: const Color(0xff1E1A0F),
  teal: const Color(0xff2DD4BF),
  transparent: Colors.transparent,
  blueGray: const Color(0xff3A3A5C),
  brown: const Color(0xff3D2B1F),
  gold: const Color(0xffF59E0B),
);

// ── Default light palette ──────────────────────────────────────────────────────
var _defaultLightColors = AppColors(
  swatch: const MaterialColor(0xff2563EB, <int, Color>{
    50: Color(0xff2563EB),
    100: Color(0xff2563EB),
    200: Color(0xff2563EB),
    300: Color(0xff2563EB),
    400: Color(0xff2563EB),
    500: Color(0xff2563EB),
    600: Color(0xff2563EB),
    700: Color(0xff2563EB),
    800: Color(0xff2563EB),
    900: Color(0xff2563EB),
  }),
  primary: const Color(0xff2563EB),
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
  blueGray: const Color(0xffC0CCDD),
  brown: const Color(0xffE3D1B5),
  gold: const Color(0xffC8933D),
);
