abstract class OnBoardingEvent {}

class NextPage extends OnBoardingEvent {}

class SkipOnBoarding extends OnBoardingEvent {}
class PageSwiped extends OnBoardingEvent {
  final int page;
  PageSwiped(this.page);
}