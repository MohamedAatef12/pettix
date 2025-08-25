import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/features/splash/persentation/bloc/splash_event.dart';
import 'package:pettix/features/splash/persentation/bloc/splash_states.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<StartAnimation>((event, emit) async {
      emit(SplashAnimating());
      await Future.delayed(const Duration(seconds: 3)); // animation duration
      emit(SplashFinished());
    });
  }
}
