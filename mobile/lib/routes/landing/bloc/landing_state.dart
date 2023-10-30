part of 'landing_bloc.dart';

sealed class LandingState {
  const LandingState();
}

class LandingInitial extends LandingState {
  const LandingInitial();
}

class LandingDisplayState extends LandingState {
  final int tabIndex;

  const LandingDisplayState({required this.tabIndex});
}

class LandingJumpToPageState extends LandingState {
  final int tabIndex;

  const LandingJumpToPageState({required this.tabIndex});
}
