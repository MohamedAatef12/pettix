abstract class OnBoardingState {
  final int currentPage;
  const OnBoardingState({required this.currentPage});
}

class OnBoardingInitial extends OnBoardingState {
  OnBoardingInitial() : super(currentPage: 0);
}

class OnBoardingPageChanged extends OnBoardingState {
  const OnBoardingPageChanged({required int currentPage})
      : super(currentPage: currentPage);
}
