part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => <Object>[];
}

class HomeLoadDisplayEvent extends HomeEvent {
  @override
  String toString() => 'Load home route';
}
