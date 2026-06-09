import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/config/di/di_wrapper.dart';
import 'package:pettix/data/caching/i_cache_manager.dart';
import 'package:pettix/data/caching/shared_prefs_helper.dart';
import 'package:pettix/features/splash/persentation/bloc/splash_event.dart';
import 'package:pettix/features/splash/persentation/bloc/splash_states.dart';
import 'package:pettix/core/services/signalr_service.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  static const _minimumSplashDuration = Duration(milliseconds: 2600);

  SplashBloc() : super(SplashInitial()) {
    on<StartAnimation>((event, emit) async {
      emit(SplashAnimating());

      final cache = DI.find<ICacheManager>();
      final minimumSplash = Future<void>.delayed(_minimumSplashDuration);
      final isRememberedFuture = cache.isRemembered();
      final isLoggedInFuture = cache.isLoggedIn();
      final isFirstOpen = SharedPrefsHelper.getBool('isFirstOpen') ?? true;

      await minimumSplash;

      final isRemembered = await isRememberedFuture;
      final isLoggedIn = await isLoggedInFuture;

      if (isLoggedIn && isRemembered) {
        DI.find<SignalRService>().start();
        emit(SplashNavigateToHome());
      } else if (isLoggedIn && !isRemembered) {
        emit(SplashNavigateToLogin());
      } else if (isFirstOpen || !isLoggedIn) {
        emit(SplashNavigateToOnBoarding());
      }
    });
  }
}
