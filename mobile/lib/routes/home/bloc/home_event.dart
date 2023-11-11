part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => <Object>[];
}

class HomeLoadDisplayEvent extends HomeEvent {
  @override
  String toString() => 'Load home route';

  @override
  List<Object?> get props => <Object>[];
}

class HomeEventPressLogout extends HomeEvent {
  @override
  String toString() => 'Logout button is pressed';

  @override
  List<Object?> get props => <Object>[];
}
