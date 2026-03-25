import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/config/env/app_config.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/caching/shared_prefs_helper.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../config/di/di_wrapper.dart';
import 'my_app.dart';
Future<void> mainCommon(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefsHelper.init();
  // Initialize dependency injection
  configureDependencies();

  // Initialize Talker logging
  final talker = TalkerFlutter.init();
  Bloc.observer = TalkerBlocObserver(talker: talker);

  // ✅ Get the already registered instance instead of re-registering
  final cache = DI.find<ICacheManager>();
  await cache.init();
  final isFirstOpen = SharedPrefsHelper.getBool('isFirstOpen');
  if (isFirstOpen == null) {
    await SharedPrefsHelper.setBool('isFirstOpen', true);
  }
  runApp( EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('ar')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: MyApp(appConfig: config),
  ),);
}

