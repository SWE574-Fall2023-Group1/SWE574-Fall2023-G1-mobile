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
  final List<StoryModel> stories;
  const HomeDisplayState({required this.stories});

  @override
  List<Object?> get props => <Object?>[stories];

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

class HomeFailure extends HomeState {
  final String? error;

  const HomeFailure({required this.error});

  @override
  List<Object?> get props => <Object?>[error];

  @override
  String toString() => 'Fetch stories failed with $error';
}

class HomeOffline extends HomeState {
  final String? offlineMessage;

  const HomeOffline({required this.offlineMessage});

  @override
  List<Object?> get props => <Object?>[offlineMessage];

  @override
  String toString() =>
      'Fetch stories service is offline with message: $offlineMessage';
}
