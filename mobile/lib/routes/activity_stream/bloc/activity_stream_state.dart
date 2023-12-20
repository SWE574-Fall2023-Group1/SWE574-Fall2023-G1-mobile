part of 'activity_stream_bloc.dart';

sealed class ActivityStreamState extends Equatable {
  const ActivityStreamState();

  @override
  List<Object?> get props => <Object?>[];
}

class ActivityStreamInitial extends ActivityStreamState {
  const ActivityStreamInitial();
}

class ActivityStreamDisplayState extends ActivityStreamState {
  final List<Activity> activities;
  final bool showLoadingAnimation;
  const ActivityStreamDisplayState(
      {required this.activities, required this.showLoadingAnimation});

  @override
  List<Object?> get props => <Object?>[activities, showLoadingAnimation];

  @override
  String toString() => 'Displaying activity stream state';
}

class ActivityStreamSuccess extends ActivityStreamState {
  const ActivityStreamSuccess();

  @override
  List<Object?> get props => <Object?>[];

  @override
  String toString() => 'Activity stream is successful';
}

class ActivityStreamFailure extends ActivityStreamState {
  final String? error;

  const ActivityStreamFailure({required this.error});

  @override
  List<Object?> get props => <Object?>[error];

  @override
  String toString() => 'Fetch activites failed with $error';
}

class ActivityStreamOffline extends ActivityStreamState {
  final String? offlineMessage;

  const ActivityStreamOffline({required this.offlineMessage});

  @override
  List<Object?> get props => <Object?>[offlineMessage];

  @override
  String toString() =>
      'Fetch activities service is offline with message: $offlineMessage';
}
