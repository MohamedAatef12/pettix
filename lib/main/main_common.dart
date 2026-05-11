import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/config/env/app_config.dart';
import 'package:pettix/core/services/notification_service.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/caching/shared_prefs_helper.dart';
import 'package:pettix/features/chat/data/data_source/chat_local_data_source.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../config/di/di_wrapper.dart';
import 'my_app.dart';

Future<void> mainCommon(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  
  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(NotificationService.onBackgroundMessage);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  
  await SharedPrefsHelper.init();
  // Initialize dependency injection
  configureDependencies();

  // Initialize Talker logging
  final talker = TalkerFlutter.init();
  Bloc.observer = TalkerBlocObserver(talker: talker);

  // Get the cache instance and initialize it
  final cache = DI.find<ICacheManager>();
  await cache.init();
  
  // Initialize Chat Cache boxes
  await DI.find<ChatLocalDataSource>().init();
  
  // Initialize Push Notifications
  await NotificationService.initialize();

  final isFirstOpen = SharedPrefsHelper.getBool('isFirstOpen');
  if (isFirstOpen == null) {
    await SharedPrefsHelper.setBool('isFirstOpen', true);
  }
  
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(appConfig: config),
    ),
  );
}
