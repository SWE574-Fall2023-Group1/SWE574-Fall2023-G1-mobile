part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => <Object?>[];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeDisplayState extends HomeState {
  const HomeDisplayState();

  @override
  List<Object?> get props => <Object?>[];

  @override
  String toString() => 'Displaying home state';
}

class HomeNavigateToLoginState extends HomeState {
  const HomeNavigateToLoginState();

  @override
  List<Object?> get props => <Object?>[];

  @override
  String toString() => 'Navigating to login page';
}
