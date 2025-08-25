import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pettix/core/themes/app_colors.dart';
import 'package:pettix/features/adoption/presentation/view/adoption_screen.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../bloc/bottom_bar_bloc.dart';
import '../bloc/bottom_bar_events.dart';
import '../bloc/bottom_bar_states.dart';

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavigationBloc(),
      child: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (context, state) {
          Widget page;
          if (state is HomePageState) {
            page = const HomePage();}
          else if (state is AdoptionState) {
            page = const AdoptionScreen();
          }
          else if (state is AdoptionState) {
            page = const AdoptionScreen();
          }
          else if (state is StoreState) {
            page = const AdoptionScreen();
          }
          else if (state is ClinicsState) {
            page = const AdoptionScreen();
          }
            else {
            page = const HomePage();
          }

          return Scaffold(
            body: page,
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: AppColors.current.primary,
                selectedItemColor: AppColors.current.white,
                unselectedItemColor: AppColors.current.white,
                showUnselectedLabels: false,
                selectedFontSize: 12.sp,
                currentIndex: state.index,
                onTap: (index) {
                  final bloc = context.read<BottomNavigationBloc>();
                  bloc.add(NavigateToPage(index));
                },
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/home.svg',
                      height: 30.r,
                      color: state.index == 0 ? AppColors.current.white : AppColors.current.lightGray,
                    ),
                    label: 'Home',

                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/adoption.svg',
                      height: 30.r,
                      color: state.index == 1 ? AppColors.current.white : AppColors.current.lightGray,
                    ),
                    label: 'Adoption',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/store.svg',
                      height: 30.r,
                      color: state.index == 2 ? AppColors.current.white : AppColors.current.lightGray,
                    ),
                    label: 'Store',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/clinics.svg',
                      height: 30.r,
                      color: state.index == 3 ? AppColors.current.white : AppColors.current.lightGray,
                    ),
                    label: 'Clinics',
                  ),
                ],
              )

            ),
          );
        },
      ),
    );
  }
}
