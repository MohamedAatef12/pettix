import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/caching/shared_prefs_helper.dart';
import 'package:pettix/features/splash/persentation/bloc/splash_event.dart';
import 'package:pettix/features/splash/persentation/bloc/splash_states.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<StartAnimation>((event, emit) async {
      emit(SplashAnimating());
      await Future.delayed(const Duration(seconds: 3));

      final cache = DI.find<ICacheManager>();
      final isRemembered = await cache.isRemembered();
      final isLoggedIn = await cache.isLoggedIn();
      final isFirstOpen = SharedPrefsHelper.getBool('isFirstOpen') ?? true;
      if (isLoggedIn && isRemembered) {
        emit(SplashNavigateToHome());
      } else if(isLoggedIn && !isRemembered) {
        emit(SplashNavigateToLogin());
      }
      else if (isFirstOpen || !isLoggedIn) {
          emit(SplashNavigateToOnBoarding());
        }
    });
  }
}

