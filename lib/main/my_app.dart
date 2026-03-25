import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/config/env/app_config.dart';
import 'package:pettix/config/router/app_router.dart';

final router = appRouter();

class MyApp extends StatelessWidget {
  final AppConfig appConfig;

  const MyApp({super.key, required this.appConfig});
  @override
  Widget build(BuildContext context) {
    final isDev = appConfig.envName == 'Development';
    return ScreenUtilInit(
      designSize: const Size(360, 760),
      builder:
          (cxt, child) => MaterialApp.router(
            title: 'Flutter ${appConfig.envName}',
            locale: context.locale, // Local'en'
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) return supportedLocales.first;
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode &&
                    supportedLocale.countryCode == locale.countryCode) {
                  return supportedLocale;
                }
              }
              return locale;
            },
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: isDev ? Colors.orange : Colors.blue,
              ),
              useMaterial3: true,
            ),
            routerConfig: router,
          ),
    );
  }
}
