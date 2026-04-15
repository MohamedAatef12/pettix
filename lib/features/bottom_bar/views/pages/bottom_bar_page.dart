import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pettix/config/router/routes.dart';
import 'package:pettix/features/adoption/presentation/view/adoption_screen.dart';
import 'package:pettix/features/home/presentation/pages/home_page.dart';
import 'package:pettix/features/profile/presentation/view/profile_screen.dart';
import 'package:pettix/features/home/presentation/blocs/home_bloc.dart';
import 'package:pettix/features/home/presentation/blocs/home_event.dart';
import 'package:pettix/features/home/presentation/blocs/home_state.dart';
import 'package:pettix/core/utils/auth_toast.dart';
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
    // AdoptionScreen(), // Placeholder for Store
    // ProfileScreen(), // Placeholder for Clinics (showing profile for now)
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BottomNavigationBloc()),
        BlocProvider(
          create: (_) => HomeBloc.fromDI()..add(FetchPostsEvent()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listenWhen: (prev, curr) =>
                curr.isPostUploadSuccess || curr.isPostUploadError,
            listener: (context, state) {
              if (state.isPostUploadSuccess) {
                AuthToast.showSuccess(context, "Post uploaded successfully!");
              } else if (state.isPostUploadError) {
                AuthToast.showError(
                    context, state.error ?? "Failed to upload post");
              }
            },
          ),
        ],
        child: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            final isIos = defaultTargetPlatform == TargetPlatform.iOS;
            return Scaffold(
              extendBody: !isIos,
              body: IndexedStack(
                index: state.index,
                children: List.generate(
                  _pages.length,
                  (i) => _LazyLoadWrapper(
                    isSelected: state.index == i,
                    child: _pages[i],
                  ),
                ),
              ),
              bottomNavigationBar: isIos
                  ? IosNavBar(
                      currentIndex: state.index,
                      onTabChanged: (i) => context
                          .read<BottomNavigationBloc>()
                          .add(NavigateToPage(i)),
                      onAddPost: () => context.push(AppRoutes.addPost,
                          extra: context.read<HomeBloc>()),
                    )
                  : AndroidNavBar(
                      currentIndex: state.index,
                      onTabChanged: (i) => context
                          .read<BottomNavigationBloc>()
                          .add(NavigateToPage(i)),
                      onAddPost: () => context.push(AppRoutes.addPost,
                          extra: context.read<HomeBloc>()),
                    ),
            );
          },
        ),
      ),
    );
  }
}

/// A wrapper that defers building its child until it is first selected.
/// This prevents Bloc initialization and API calls in [IndexedStack]
/// for tabs that haven't been visited yet.
class _LazyLoadWrapper extends StatefulWidget {
  final Widget child;
  final bool isSelected;

  const _LazyLoadWrapper({required this.child, required this.isSelected});

  @override
  State<_LazyLoadWrapper> createState() => _LazyLoadWrapperState();
}

class _LazyLoadWrapperState extends State<_LazyLoadWrapper> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.isSelected) _initialized = true;
  }

  @override
  void didUpdateWidget(_LazyLoadWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !_initialized) {
      setState(() => _initialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const SizedBox.shrink();
    return widget.child;
  }
}
