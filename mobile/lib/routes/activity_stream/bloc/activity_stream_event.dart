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

class ActivityStreamOnPressActivityEvent extends ActivityStreamEvent {
  final int activityId;

  const ActivityStreamOnPressActivityEvent({required this.activityId});
  @override
  String toString() => 'Navigate to target user profile';

  @override
  List<Object?> get props => <Object>[activityId];
}
