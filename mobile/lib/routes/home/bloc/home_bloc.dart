import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:memories_app/routes/home/model/home_repository.dart';
import 'package:memories_app/routes/home/model/request/user_stories_request_model.dart';
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
  }

  List<StoryModel> _stories = <StoryModel>[];
  final int _page = 1;

  HomeDisplayState _displayState() {
    return HomeDisplayState(stories: _stories);
  }

  Future<void> _onLoadDisplayEvent(
      HomeLoadDisplayEvent event, Emitter<HomeState> emit) async {
    try {
      _stories = await loadPosts(_page);
      emit(_displayState());
    } on SocketException {
      emit(const HomeOffline(offlineMessage: _Constants.offlineMessage));
    } catch (error) {
      emit(HomeFailure(error: error.toString()));
    }
  }

  Future<List<StoryModel>> loadPosts(int page) async {
    UserStoriesRequestModel requestModel =
        UserStoriesRequestModel(page: page, size: _Constants.size);

    StoriesResponseModel? responseModel;

    responseModel = await HomeRepositoryImp().getUserStories(requestModel);

    return responseModel.stories ?? <StoryModel>[];
  }

  Future<void> _onPressLogout(
      HomeEventPressLogout event, Emitter<HomeState> emit) async {
    await SPHelper.clear();
    emit(const HomeNavigateToLoginState());
  }
}
