part of 'app_bloc.dart';

sealed class AppEvent extends Equatable {
  @override
  List<Object> get props => <Object>[];
}

class AppStarted extends AppEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AppEvent {
  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends AppEvent {
  @override
  String toString() => 'LoggedOut';
}
