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
  final List<Activity> allActivities;
  final List<Activity> newStories;
  final List<Activity> likedStories;
  final List<Activity> unlikedStories;
  final List<Activity> followedUser;
  final List<Activity> unfollowedUser;
  final List<Activity> commentOnStory;
  final List<Activity> commentStoryYouCommentedBefore;

  final bool showLoadingAnimation;
  const ActivityStreamDisplayState(
      {required this.allActivities,
      required this.likedStories,
      required this.unlikedStories,
      required this.followedUser,
      required this.unfollowedUser,
      required this.commentOnStory,
      required this.commentStoryYouCommentedBefore,
      required this.newStories,
      required this.showLoadingAnimation});

  @override
  List<Object?> get props => <Object?>[
        likedStories,
        unlikedStories,
        followedUser,
        unfollowedUser,
        commentOnStory,
        commentStoryYouCommentedBefore,
        newStories,
        showLoadingAnimation
      ];

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
