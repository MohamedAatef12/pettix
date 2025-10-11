import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pettix/features/on_boarding/presentation/bloc/on_boarding_events.dart';
import 'package:pettix/features/on_boarding/presentation/bloc/on_boarding_states.dart';
import 'package:pettix/features/on_boarding/presentation/view/widgets/on_boarding_slides.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  final List<OnBoardingSlide> slides = [
    OnBoardingSlide(
      image: "assets/images/on_boarding1.png",
      title: "Connect with Pet Lovers",
      desc: "Share your pet’s daily adventures, post cute pictures, and engage with a loving pet community  just like you!",
    ),
    OnBoardingSlide(
      image: "assets/images/on_boarding2.png",
      title: "Care. Safety. Second Chances.",
      desc: "Find loving homes for pets, access trusted clinics, or get urgent help in emergencies — all in one  convenient place.",
    ),
    OnBoardingSlide(
      image: "assets/images/on_boarding3.png",
      title: "Everything Your Pet Needs.",
      desc: "Discover food, toys, and grooming essentials.  Shop easily for your furry friend from  trusted pet brands.",
    ),
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
