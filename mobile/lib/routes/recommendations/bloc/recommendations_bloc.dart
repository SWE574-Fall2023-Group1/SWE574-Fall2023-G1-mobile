// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:io';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/recommendations/model/recommendations_repository.dart';
import 'package:memories_app/routes/recommendations/model/recommendations_response.dart';

part 'recommendations_event.dart';
part 'recommendations_state.dart';

class _Constants {
  static const String offlineMessage =
      'You are currently offline.\n Please check your internet connection!';
}

class RecommendationsBloc
    extends Bloc<RecommendationsEvent, RecommendationsState> {
  final RecommendationsRepository _repository;

  RecommendationsBloc({required RecommendationsRepository repository})
      : _repository = repository,
        super(const RecommendationsInitial()) {
    on<RecommendationsLoadDisplayEvent>(_recommendationsEvent);
    on<RecommendationsEventRefreshStories>(_refreshStories);
  }

  Future<void> _recommendationsEvent(RecommendationsLoadDisplayEvent event,
      Emitter<RecommendationsState> emit) async {
    RecommendationsResponseModel? response;
    await _getRecommendations(response, emit);
  }

  Future<void> _refreshStories(RecommendationsEventRefreshStories event,
      Emitter<RecommendationsState> emit) async {
    RecommendationsResponseModel? response;

    await _getRecommendations(response, emit);
  }

  Future<void> _getRecommendations(RecommendationsResponseModel? response,
      Emitter<RecommendationsState> emit) async {
    try {
      response = await _repository.getRecommendations();
    } on SocketException {
      emit(const RecommendationsOffline(
          offlineMessage: _Constants.offlineMessage));
    } catch (error) {
      emit(RecommendationsFailure(error: error.toString()));
    }
    if (response != null) {
      if (response.success == true &&
          response.recommendations != null &&
          response.recommendations!.isNotEmpty) {
        response.recommendations!
            .forEach((Recommendation recommendation) async {
          recommendation.story!.dateText =
              _getFormattedDate(recommendation.story!);
        });

        emit(RecommendationsDisplayState(
            recommendations: response.recommendations!,
            showLoadingAnimation: false));
      } else {
        emit(RecommendationsFailure(error: response.msg.toString()));
      }
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

      String formattedDate = isMidnight
          ? dateTime.toLocal().toLocal().toString().split(' ')[0]
          : dateTime.toLocal().toLocal().toString();

      return formattedDate;
    } catch (e) {
      // ignore: avoid_print
      print('Error parsing date: $e');
      return null;
    }
  }
}
