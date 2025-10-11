import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di.dart';
import 'package:pettix/config/env/app_config.dart';
import 'package:pettix/data/caching/cache_manager.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../config/di/di_wrapper.dart';
import 'my_app.dart';
Future<void> mainCommon(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize dependency injection
  configureDependencies();

  // Initialize Talker logging
  final talker = TalkerFlutter.init();
  Bloc.observer = TalkerBlocObserver(talker: talker);

  // ✅ Get the already registered instance instead of re-registering
  final cache = DI.find<ICacheManager>();
  await cache.init();

  runApp(MyApp(appConfig: config));
}

