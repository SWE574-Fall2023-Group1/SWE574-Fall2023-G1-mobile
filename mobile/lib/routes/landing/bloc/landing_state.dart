part of 'landing_bloc.dart';

sealed class LandingState {
  final int tabIndex;

  const LandingState({required this.tabIndex});
}

class LandingInitial extends LandingState {
  const LandingInitial({required super.tabIndex});
}
