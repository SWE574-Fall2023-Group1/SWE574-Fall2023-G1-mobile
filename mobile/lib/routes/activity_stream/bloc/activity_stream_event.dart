part of 'activity_stream_bloc.dart';

sealed class ActivityStreamEvent extends Equatable {
  const ActivityStreamEvent();

  @override
  List<Object?> get props => <Object>[];
}

class ActivityStreamLoadDisplayEvent extends ActivityStreamEvent {
  @override
  String toString() => 'Load activity stream route';

  @override
  List<Object?> get props => <Object>[];
}
