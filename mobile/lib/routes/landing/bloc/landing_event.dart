part of 'landing_bloc.dart';

sealed class LandingEvent {}

class LandingTabChangeEvent extends LandingEvent {
  final int tabIndex;

  LandingTabChangeEvent({required this.tabIndex});
}
