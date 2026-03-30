import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/core/constants/app_texts.dart';
import 'package:pettix/features/on_boarding/presentation/bloc/on_boarding_events.dart';
import 'package:pettix/features/on_boarding/presentation/bloc/on_boarding_states.dart';
import 'package:pettix/features/on_boarding/presentation/view/widgets/on_boarding_slides.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final List<OnBoardingSlide> slides = [
    OnBoardingSlide(
      image: "assets/images/on_boarding1.png",
      title: AppText.connectWithPetLovers,
      desc: AppText.shareDailyAdventures,
    ),
    OnBoardingSlide(
      image: "assets/images/on_boarding2.png",
      title: AppText.careSafetySecondChances,
      desc:  AppText.findLovingHomes
    ),
    OnBoardingSlide(
      image: "assets/images/on_boarding3.png",
      title: AppText.everythingYourPetNeeds,
      desc: AppText.discoverFoodToys  ),
  ];

  OnBoardingBloc() : super(OnBoardingInitial()) {
    on<NextPage>((event, emit) {
      if (state.currentPage < slides.length - 1) {
        emit(OnBoardingPageChanged(currentPage: state.currentPage + 1));
      }
    });
    on<PageSwiped>((event, emit) {
      emit(OnBoardingPageChanged(currentPage: event.page));
    });
    on<SkipOnBoarding>((event, emit) {
      emit(OnBoardingPageChanged(currentPage: slides.length - 1));
    });
  }
}
