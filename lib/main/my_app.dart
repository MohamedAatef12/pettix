import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/config/env/app_config.dart';
import 'package:pettix/config/router/app_router.dart';
import 'package:pettix/core/bloc/theme/theme_cubit.dart';
import 'package:pettix/core/bloc/theme/theme_option.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/core/themes/dark_theme.dart';
import 'package:pettix/core/themes/extra_themes.dart';
import 'package:pettix/core/themes/light_theme.dart';

final router = appRouter();

class MyApp extends StatelessWidget {
  final AppConfig appConfig;

  const MyApp({super.key, required this.appConfig});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, AppThemeOption>(
        builder: (ctx, themeOption) {
          AppColors.current = switch (themeOption) {
            AppThemeOption.blueLight => AppColors.light,
            AppThemeOption.roseLight => AppColors.roseLight,
            AppThemeOption.indigoDark => AppColors.dark,
            AppThemeOption.oceanDark => AppColors.oceanDark,
            AppThemeOption.emeraldLight => AppColors.emeraldLight,
            AppThemeOption.sunriseLight => AppColors.sunriseLight,
            AppThemeOption.forestDark => AppColors.forestDark,
            AppThemeOption.emberDark => AppColors.emberDark,
            AppThemeOption.lavenderLight => AppColors.lavenderLight,
            AppThemeOption.coralLight => AppColors.coralLight,
            AppThemeOption.mintLight => AppColors.mintLight,
            AppThemeOption.graphiteLight => AppColors.graphiteLight,
            AppThemeOption.neonDark => AppColors.neonDark,
            AppThemeOption.auroraDark => AppColors.auroraDark,
            AppThemeOption.plumDark => AppColors.plumDark,
            AppThemeOption.rubyDark => AppColors.rubyDark,
          };
          final effectiveTheme = switch (themeOption) {
            AppThemeOption.blueLight => lightTheme,
            AppThemeOption.roseLight => roseLightTheme,
            AppThemeOption.indigoDark => darkTheme,
            AppThemeOption.oceanDark => oceanDarkTheme,
            AppThemeOption.emeraldLight => emeraldLightTheme,
            AppThemeOption.sunriseLight => sunriseLightTheme,
            AppThemeOption.forestDark => forestDarkTheme,
            AppThemeOption.emberDark => emberDarkTheme,
            AppThemeOption.lavenderLight => lavenderLightTheme,
            AppThemeOption.coralLight => coralLightTheme,
            AppThemeOption.mintLight => mintLightTheme,
            AppThemeOption.graphiteLight => graphiteLightTheme,
            AppThemeOption.neonDark => neonDarkTheme,
            AppThemeOption.auroraDark => auroraDarkTheme,
            AppThemeOption.plumDark => plumDarkTheme,
            AppThemeOption.rubyDark => rubyDarkTheme,
          };
          return ScreenUtilInit(
            designSize: const Size(360, 760),
            builder:
                (_, __) => MaterialApp.router(
                  title: 'Pettix',
                  locale: context.locale,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  localeResolutionCallback: (locale, supportedLocales) {
                    if (locale == null) return supportedLocales.first;
                    for (final supported in supportedLocales) {
                      if (supported.languageCode == locale.languageCode &&
                          supported.countryCode == locale.countryCode) {
                        return supported;
                      }
                    }
                    return locale;
                  },
                  debugShowCheckedModeBanner: false,
                  theme: effectiveTheme,
                  routerConfig: router,
                ),
          );
        },
      ),
    );
  }
}
