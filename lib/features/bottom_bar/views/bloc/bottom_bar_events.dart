import 'package:equatable/equatable.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigateToPage extends BottomNavigationEvent {
  final int index;

  const NavigateToPage(this.index);

  @override
  List<Object> get props => [index];
}
