import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum AppThemeOption {
  blueLight,
  roseLight,
  indigoDark,
  oceanDark,
  emeraldLight,
  sunriseLight,
  forestDark,
  emberDark,
  lavenderLight,
  coralLight,
  mintLight,
  graphiteLight,
  neonDark,
  auroraDark,
  plumDark,
  rubyDark,
  peachLight,
  skyLight,
  ivoryLight,
  slateLight,
  voidDark,
  crimsonDark,
  navyDark,
  jadeDark,
}

extension AppThemeOptionX on AppThemeOption {
  bool get isDark => switch (this) {
    AppThemeOption.indigoDark ||
    AppThemeOption.oceanDark ||
    AppThemeOption.forestDark ||
    AppThemeOption.emberDark ||
    AppThemeOption.neonDark ||
    AppThemeOption.auroraDark ||
    AppThemeOption.plumDark ||
    AppThemeOption.rubyDark ||
    AppThemeOption.voidDark ||
    AppThemeOption.crimsonDark ||
    AppThemeOption.navyDark ||
    AppThemeOption.jadeDark => true,
    _ => false,
  };

  ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;

  String get label => switch (this) {
    AppThemeOption.blueLight => 'Blue Sky'.tr(),
    AppThemeOption.roseLight => 'Warm Rose'.tr(),
    AppThemeOption.indigoDark => 'Midnight Indigo'.tr(),
    AppThemeOption.oceanDark => 'Deep Ocean'.tr(),
    AppThemeOption.emeraldLight => 'Emerald Garden'.tr(),
    AppThemeOption.sunriseLight => 'Golden Sunrise'.tr(),
    AppThemeOption.forestDark => 'Forest Night'.tr(),
    AppThemeOption.emberDark => 'Ember Glow'.tr(),
    AppThemeOption.lavenderLight => 'Lavender Mist'.tr(),
    AppThemeOption.coralLight => 'Coral Reef'.tr(),
    AppThemeOption.mintLight => 'Arctic Mint'.tr(),
    AppThemeOption.graphiteLight => 'Graphite Lime'.tr(),
    AppThemeOption.neonDark => 'Neon Noir'.tr(),
    AppThemeOption.auroraDark => 'Aurora Dark'.tr(),
    AppThemeOption.plumDark => 'Plum Velvet'.tr(),
    AppThemeOption.rubyDark => 'Slate Ruby'.tr(),
    AppThemeOption.peachLight => 'Peach Blossom'.tr(),
    AppThemeOption.skyLight => 'Sky Fresh'.tr(),
    AppThemeOption.ivoryLight => 'Warm Ivory'.tr(),
    AppThemeOption.slateLight => 'Slate Indigo'.tr(),
    AppThemeOption.voidDark => 'Void'.tr(),
    AppThemeOption.crimsonDark => 'Crimson Night'.tr(),
    AppThemeOption.navyDark => 'Deep Navy'.tr(),
    AppThemeOption.jadeDark => 'Dark Jade'.tr(),
  };

  String get brightnessLabel => isDark ? 'Dark'.tr() : 'Light'.tr();

  Color get previewColor => switch (this) {
    AppThemeOption.blueLight => const Color(0xff2563EB),
    AppThemeOption.roseLight => const Color(0xffF43F5E),
    AppThemeOption.indigoDark => const Color(0xff7C3AED),
    AppThemeOption.oceanDark => const Color(0xff06B6D4),
    AppThemeOption.emeraldLight => const Color(0xff00A676),
    AppThemeOption.sunriseLight => const Color(0xffF97316),
    AppThemeOption.forestDark => const Color(0xff22C55E),
    AppThemeOption.emberDark => const Color(0xffF97316),
    AppThemeOption.lavenderLight => const Color(0xff8B5CF6),
    AppThemeOption.coralLight => const Color(0xffFF5A5F),
    AppThemeOption.mintLight => const Color(0xff14B8A6),
    AppThemeOption.graphiteLight => const Color(0xff475569),
    AppThemeOption.neonDark => const Color(0xffA855F7),
    AppThemeOption.auroraDark => const Color(0xff38BDF8),
    AppThemeOption.plumDark => const Color(0xffD946EF),
    AppThemeOption.rubyDark => const Color(0xffFB7185),
    AppThemeOption.peachLight => const Color(0xffF472B6),
    AppThemeOption.skyLight => const Color(0xff0EA5E9),
    AppThemeOption.ivoryLight => const Color(0xffB45309),
    AppThemeOption.slateLight => const Color(0xff6366F1),
    AppThemeOption.voidDark => const Color(0xffA78BFA),
    AppThemeOption.crimsonDark => const Color(0xffF87171),
    AppThemeOption.navyDark => const Color(0xff60A5FA),
    AppThemeOption.jadeDark => const Color(0xff34D399),
  };

  Color get previewAccent => switch (this) {
    AppThemeOption.blueLight => const Color(0xff13D586),
    AppThemeOption.roseLight => const Color(0xffFB7185),
    AppThemeOption.indigoDark => const Color(0xff2DD4BF),
    AppThemeOption.oceanDark => const Color(0xff4ADE80),
    AppThemeOption.emeraldLight => const Color(0xffFF7A59),
    AppThemeOption.sunriseLight => const Color(0xff0EA5E9),
    AppThemeOption.forestDark => const Color(0xffF59E0B),
    AppThemeOption.emberDark => const Color(0xffF43F5E),
    AppThemeOption.lavenderLight => const Color(0xff06B6D4),
    AppThemeOption.coralLight => const Color(0xff00B8A9),
    AppThemeOption.mintLight => const Color(0xff3B82F6),
    AppThemeOption.graphiteLight => const Color(0xff84CC16),
    AppThemeOption.neonDark => const Color(0xff22D3EE),
    AppThemeOption.auroraDark => const Color(0xffA3E635),
    AppThemeOption.plumDark => const Color(0xffF59E0B),
    AppThemeOption.rubyDark => const Color(0xff60A5FA),
    AppThemeOption.peachLight => const Color(0xff06B6D4),
    AppThemeOption.skyLight => const Color(0xff14B8A6),
    AppThemeOption.ivoryLight => const Color(0xff0D9488),
    AppThemeOption.slateLight => const Color(0xff06B6D4),
    AppThemeOption.voidDark => const Color(0xff22D3EE),
    AppThemeOption.crimsonDark => const Color(0xff34D399),
    AppThemeOption.navyDark => const Color(0xff38BDF8),
    AppThemeOption.jadeDark => const Color(0xff22D3EE),
  };
}
