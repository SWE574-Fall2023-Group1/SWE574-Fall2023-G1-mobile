import 'dart:io';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memories_app/routes/activity_stream/model/activity_stream_repository.dart';
import 'package:memories_app/routes/activity_stream/model/activity_stream_response_model.dart';

part 'activity_stream_event.dart';
part 'activity_stream_state.dart';

class _Constants {
  static const String offlineMessage =
      'You are currently offline.\n Please check your internet connection!';
}

class ActivityStreamBloc
    extends Bloc<ActivityStreamEvent, ActivityStreamState> {
  final ActivityStreamRepository _repository;

  ActivityStreamBloc({required ActivityStreamRepository repository})
      : _repository = repository,
        super(const ActivityStreamInitial()) {
    on<ActivityStreamLoadDisplayEvent>(_loadDisplayEvent);
  }

  List<Activity> likedStories = <Activity>[];
  List<Activity> unlikedStories = <Activity>[];
  List<Activity> followedUser = <Activity>[];
  List<Activity> unfollowedUser = <Activity>[];
  List<Activity> commentOnStory = <Activity>[];
  List<Activity> commentStoryYouCommentedBefore = <Activity>[];
  List<Activity> newStories = <Activity>[];

  Future<void> _loadDisplayEvent(ActivityStreamLoadDisplayEvent event,
      Emitter<ActivityStreamState> emit) async {
    ActivityStreamResponseModel? response;
    await _getActivities(response, emit);
  }

  Future<void> _getActivities(ActivityStreamResponseModel? response,
      Emitter<ActivityStreamState> emit) async {
    try {
      response = await _repository.getActivities();
    } on SocketException {
      emit(const ActivityStreamOffline(
          offlineMessage: _Constants.offlineMessage));
    } catch (error) {
      emit(ActivityStreamFailure(error: error.toString()));
    }

    if (response != null) {
      if (response.success == true) {
        _groupActivities(response.activity);
        emit(ActivityStreamDisplayState(
          allActivities: response.activity,
          showLoadingAnimation: false,
          likedStories: likedStories,
          commentOnStory: commentOnStory,
          commentStoryYouCommentedBefore: commentStoryYouCommentedBefore,
          followedUser: followedUser,
          newStories: newStories,
          unfollowedUser: unfollowedUser,
          unlikedStories: unlikedStories,
        ));
      } else {
        emit(ActivityStreamFailure(error: response.msg.toString()));
      }
    }
  }

  void _groupActivities(List<Activity> activities) {
    for (Activity element in activities) {
      if (element.activityType == "new_story" && !element.viewed) {
        newStories.add(element);
      }
      if (element.activityType == "story_liked" && !element.viewed) {
        likedStories.add(element);
      }
      if (element.activityType == "story_unliked" && !element.viewed) {
        unlikedStories.add(element);
      }
      if (element.activityType == "followed_user" && !element.viewed) {
        followedUser.add(element);
      }
      if (element.activityType == "unfollowed_user" && !element.viewed) {
        unfollowedUser.add(element);
      }
      if (element.activityType == "new_commented_on_story" && !element.viewed) {
        commentOnStory.add(element);
      }
      if (element.activityType == "new_comment_on_comment" && !element.viewed) {
        commentStoryYouCommentedBefore.add(element);
      }
    }
  }
}
