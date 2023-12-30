import 'dart:async';
import 'dart:io';
import 'package:flutter_map/flutter_map.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/search/model/search_story_repository.dart';
import 'package:memories_app/routes/search/model/search_story_request_model.dart';
import 'package:memories_app/routes/search/model/search_story_response_model.dart';

part 'search_story_event.dart';
part 'search_story_state.dart';

class _Constants {
  static const String errorMessage =
      'Error searching stories.\n Please check your request';
  static const String errorEmptyStories =
      'Cannot find any stories with your search';
  static const String offlineMessage =
      'You are currently offline.\n Please check your internet connection!';
}

class SearchStoryBloc extends Bloc<SearchStoryEvent, SearchStoryState> {
  final SearchStoryRepository _repository;

  SearchStoryBloc({required SearchStoryRepository repository})
      : _repository = repository,
        super(const SearchStoryState()) {
    on<SearchStoryEventSearchPressed>(_searchStory);
    on<SearchStoryErrorPopupClosedEvent>(_onErrorPopupClosed);
  }

  Future<void> _searchStory(SearchStoryEventSearchPressed event,
      Emitter<SearchStoryState> emit) async {
    final SearchStoryRequestModel model = createSearchModel(event);
    SearchStoryResponseModel? response;

    try {
      response = await _repository.searchStory(model);
    } on SocketException {
      emit(const SearchStoryOffline(offlineMessage: _Constants.offlineMessage));
    } catch (error) {
      emit(SearchStoryFailure(error: error.toString()));
    }

    if (response != null) {
      if (response.stories != null) {
        if (response.stories!.isNotEmpty) {
          emit(SearchStorySuccess(response.stories));
        } else {
          emit(const SearchStoryFailure(error: _Constants.errorEmptyStories));
        }
      } else {
        emit(const SearchStoryFailure(error: _Constants.errorMessage));
      }
    }
  }

  SearchStoryRequestModel createSearchModel(
      SearchStoryEventSearchPressed event) {
    final String dateType = mapDateTypeToValue(event.timeType!.toLowerCase());

    return SearchStoryRequestModel(
        title: event.title,
        author: event.author,
        tag: event.tag,
        tagLabel: event.tagLabel,
        timeType: dateType,
        timeValue: setTimeModel(event),
        location: setLocationModel(event),
        radiusDiff: event.radius,
        dateDiff: event.dateDiff);
  }

  TimeValue? setTimeModel(SearchStoryEventSearchPressed event) {
    if (event.timeType == "Year") {
      return NormalYear(
          year: event.year ?? "", seasonName: event.seasonName ?? "");
    }
    if (event.timeType == "Interval Year") {
      return IntervalYear(
          startYear: event.startYear ?? "",
          endYear: event.endYear ?? "",
          seasonName: event.seasonName ?? "");
    }

    if (event.timeType == "Date") {
      return NormalDate(date: event.date ?? "");
    }

    if (event.timeType == "Interval Date") {
      return IntervalDate(
          startDate: event.startDate ?? "", endDate: event.endDate ?? "");
    }

    if (event.timeType == "Decade") {
      return Decade(decade: extractDecade(event.decade) ?? 1900);
    }
    return null;
  }

  Location? setLocationModel(SearchStoryEventSearchPressed event) {
    if (event.marker != null) {
      return Location(coordinates: <double>[
        event.marker!.point.longitude,
        event.marker!.point.latitude
      ], type: "Point");
    } else {
      return null;
    }
  }

  int? extractDecade(String? decade) {
    if (decade == null || decade.isEmpty) {
      return null;
    }

    // Remove trailing 's' and parse the remaining part as an integer
    String numericPart = decade.substring(0, decade.length - 1);
    return int.tryParse(numericPart);
  }

  void _onErrorPopupClosed(
      SearchStoryErrorPopupClosedEvent event, Emitter<SearchStoryState> emit) {
    emit(const SearchStoryState());
  }

  String mapDateTypeToValue(String selectedDateType) {
    switch (selectedDateType.toLowerCase()) {
      case "year":
        return "year";
      case "interval year":
        return "year_interval";
      case "normal date":
        return "normal_date";
      case "interval date":
        return "interval_date";
      case "decade":
        return "decade";
      default:
        return "year";
    }
  }
}
