import 'package:equatable/equatable.dart';

abstract class BottomNavigationState extends Equatable {
  const BottomNavigationState();

  int get index;

  @override
  List<Object> get props => [];
}

class HomePageState extends BottomNavigationState {
  @override
  int get index => 0;
}

class AdoptionState extends BottomNavigationState {
  @override
  int get index => 1;
}

class StoreState extends BottomNavigationState {
  @override
  int get index => 2;
}
class ClinicsState extends BottomNavigationState {
  @override
  int get index => 3;
}
