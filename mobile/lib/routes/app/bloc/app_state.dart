part of 'app_bloc.dart';

sealed class AppState extends Equatable {
  const AppState();
  @override
  List<Object> get props => <Object>[];
}

class AppInitial extends AppState {
  const AppInitial();
}

class AppAuthenticated extends AppState {
  const AppAuthenticated();

  @override
  String toString() => 'AppAuthenticated';
}

class AppUnauthenticated extends AppState {
  const AppUnauthenticated();

  @override
  String toString() => 'AppUnauthenticated';
}

class AppLoading extends AppState {
  const AppLoading();

  @override
  String toString() => 'AppLoading';
}
