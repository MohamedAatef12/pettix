import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/features/adoption/presentation/view/adoption_screen.dart';
import 'package:pettix/features/home/presentation/pages/home_page.dart';
import 'package:pettix/features/profile/presentation/view/profile_screen.dart';
import '../bloc/bottom_bar_bloc.dart';
import '../bloc/bottom_bar_events.dart';
import '../bloc/bottom_bar_states.dart';
import '../widgets/android_nav_bar.dart';
import '../widgets/ios_nav_bar.dart';

/// Root scaffold that hosts the bottom navigation and switches pages.
///
/// Renders [IosNavBar] on iOS and [AndroidNavBar] on all other platforms
/// based on [defaultTargetPlatform]. Uses [IndexedStack] to preserve each
/// page's state across tab switches.
class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  static const _pages = <Widget>[
    HomePage(),
    AdoptionScreen(),
    AdoptionScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavigationBloc(),
      child: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (context, state) {
          final isIos = defaultTargetPlatform == TargetPlatform.iOS;
          return Scaffold(
            extendBody: !isIos,
            body: IndexedStack(
              index: state.index,
              children: _pages,
            ),
            bottomNavigationBar: isIos
                ? IosNavBar(
                    currentIndex: state.index,
                    onTabChanged: (i) => context
                        .read<BottomNavigationBloc>()
                        .add(NavigateToPage(i)),
                    onAddPost: () => context.push(AppRoutes.addPost),
                  )
                : AndroidNavBar(
                    currentIndex: state.index,
                    onTabChanged: (i) => context
                        .read<BottomNavigationBloc>()
                        .add(NavigateToPage(i)),
                    onAddPost: () => context.push(AppRoutes.addPost),
                  ),
          );
        },
      ),
    );
  }
}
