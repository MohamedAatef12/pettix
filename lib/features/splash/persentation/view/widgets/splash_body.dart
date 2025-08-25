import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pettix/features/splash/persentation/bloc/splash_bloc.dart';
import 'package:pettix/features/splash/persentation/bloc/splash_event.dart';
import 'package:pettix/features/splash/persentation/bloc/splash_states.dart';

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashBloc, SplashState>(
      builder: (context, state) {
        bool animate = state is SplashAnimating || state is SplashFinished;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),

            // ✅ Animated Logo
            AnimatedSlide(
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeOutQuart,
              offset: animate ? Offset.zero : const Offset(-1.5, 0),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                opacity: animate ? 1.0 : 0.0,
                child: Center(
                  child: Image.asset(
                    'assets/images/labeled_logo.png',
                    width: 150.w,
                    height: 178.h,
                  ),
                ),
              ),
            ),

            // Static second image
            Image.asset(
              'assets/images/splash.png',
              width: 262.w,
              height: 246.h,
            ),
          ],
        );
      },
    );
  }
}
