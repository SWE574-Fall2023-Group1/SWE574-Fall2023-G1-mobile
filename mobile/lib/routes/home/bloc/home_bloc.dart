import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:memories_app/routes/app/application_context.dart';
import 'package:memories_app/routes/home/model/home_repository.dart';
import 'package:memories_app/routes/home/model/response/stories_response_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/util/sp_helper.dart';

part 'home_event.dart';

part 'home_state.dart';

class _Constants {
  static const int size = 5;
  static const String offlineMessage =
      'You are currently offline.\n Please check your internet connection!';
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<HomeLoadDisplayEvent>(_onLoadDisplayEvent);
    on<HomeEventPressLogout>(_onPressLogout);
    on<HomeEventLoadMoreStory>(_onLoadMoreStory);
    on<HomeEventRefreshStories>(_onRefreshStories);
  }

  List<StoryModel> _stories = <StoryModel>[];
  int _page = 1;
  bool _showLoadingAnimation = false;

  HomeDisplayState _displayState() {
    return HomeDisplayState(
        stories: _stories, showLoadingAnimation: _showLoadingAnimation);
  }

  Future<void> _onLoadDisplayEvent(
      HomeLoadDisplayEvent event, Emitter<HomeState> emit) async {
    try {
      _stories = await _loadPosts(_page);
      /* _stories.forEach((StoryModel element) {
        print("TEST1: ${element.id}");

      });*/
      emit(_displayState());
    } on SocketException {
      emit(const HomeOffline(offlineMessage: _Constants.offlineMessage));
    } catch (error) {
      emit(HomeFailure(error: error.toString()));
    }
  }

  Future<List<StoryModel>> _loadPosts(int page) async {
    StoriesResponseModel? responseModel;

    responseModel = await HomeRepositoryImp()
        .getAllStoriesWithOwnUrl(page: page, size: _Constants.size);
    if (responseModel.stories != null) {
      responseModel.stories?.forEach((StoryModel story) async {
        story.dateText = _getFormattedDate(story);
        story.isEditable = await _onGetIsEditable(story);
      });
    }
    return responseModel.stories ?? <StoryModel>[];
  }

  Future<void> _onPressLogout(
      HomeEventPressLogout event, Emitter<HomeState> emit) async {
    await SPHelper.clear();
    emit(const HomeNavigateToLoginState());
  }

  FutureOr<void> _onLoadMoreStory(
      HomeEventLoadMoreStory event, Emitter<HomeState> emit) async {
    _showLoadingAnimation = true;
    emit(_displayState());

    _page++;
    List<StoryModel> newStories = await _loadPosts(_page);

    Set<int> uniqueStoryIds =
        Set<int>.from(_stories.map((StoryModel story) => story.id));

    List<StoryModel> filteredNewStories = newStories
        .where((StoryModel story) => uniqueStoryIds.add(story.id))
        .toList();

    _stories.addAll(filteredNewStories);

    /*_stories.forEach((StoryModel element) {
      print("TEST2: ${element.id}");
    });*/

    _showLoadingAnimation = false;

    emit(_displayState());
  }

  FutureOr<void> _onRefreshStories(
      HomeEventRefreshStories event, Emitter<HomeState> emit) async {
    _page = 1;
    try {
      _stories = await _loadPosts(_page);
      /*_stories.forEach((StoryModel element) {
        print("TEST3: ${element.id}");
      });*/
      emit(_displayState());
    } on SocketException {
      emit(const HomeOffline(offlineMessage: _Constants.offlineMessage));
    } catch (error) {
      emit(HomeFailure(error: error.toString()));
    }
  }

  String _getFormattedDate(StoryModel story) {
    switch (story.dateType) {
      case 'year':
        return 'Year: ${story.year?.toString() ?? ''}';
      case 'decade':
        return 'Decade: ${story.decade?.toString() ?? ''}';
      case 'year_interval':
        return 'Start: ${story.startYear.toString()} \nEnd: ${story.endYear.toString()}';
      case 'normal_date':
        return _formatDate(story.date) ?? '';
      case 'interval_date':
        return 'Start: ${_formatDate(story.startDate)} \nEnd: ${_formatDate(story.endDate)}';
      default:
        return '';
    }
  }

  String? _formatDate(String? dateString) {
    if (dateString == null) {
      return null;
    }

    try {
      DateTime dateTime = DateTime.parse(dateString);

      bool isMidnight =
          dateTime.hour == 0 && dateTime.minute == 0 && dateTime.second == 0;

      String pattern = isMidnight ? 'yyyy-MM-dd' : 'yyyy-MM-dd HH:mm';

      String formattedDate = DateFormat(pattern).format(dateTime.toLocal());

      return formattedDate;
    } catch (e) {
      // ignore: avoid_print
      print('Error parsing date: $e');
      return null;
    }
  }

  Future<bool> _onGetIsEditable(StoryModel story) async {
    int? currentUserId = await SPHelper.getInt(SPKeys.currentUserId);
    ApplicationContext.currentUserId = currentUserId ?? 0;
    return story.author == currentUserId &&
        story.author != null &&
        currentUserId != null;
  }
}
