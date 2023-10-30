part of 'landing_bloc.dart';

sealed class LandingEvent {}

class LandingLoadEvent extends LandingEvent {
  final int tabIndex;
  LandingLoadEvent({required this.tabIndex});
}

class LandingOnPageChangedEvent extends LandingEvent {
  final int tabIndex;

  LandingOnPageChangedEvent({required this.tabIndex});
}
