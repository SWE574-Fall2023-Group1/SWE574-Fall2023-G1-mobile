part of 'search_story_bloc.dart';

sealed class SearchStoryEvent extends Equatable {
  const SearchStoryEvent();
}

class SearchStoryEventSearchPressed extends SearchStoryEvent {
  final String? title;
  final String? author;
  final String? tag;
  final String? tagLabel;
  final String? timeType;
  final String? seasonName;
  final String? startYear;
  final String? endYear;
  final String? year;
  final String? date;
  final String? startDate;
  final String? endDate;
  final int? decade;
  final Marker? marker;
  final int radius;
  final int? dateDiff;

  const SearchStoryEventSearchPressed({
    this.title,
    this.author,
    this.tag,
    this.tagLabel,
    this.timeType,
    this.seasonName,
    this.startYear,
    this.endYear,
    this.year,
    this.date,
    this.startDate,
    this.endDate,
    this.decade = 1900,
    this.marker,
    this.radius = 25,
    this.dateDiff,
  });

  @override
  List<Object?> get props => <Object?>[
        title,
        author,
        tag,
        tagLabel,
        timeType,
        seasonName,
        startYear,
        endYear,
        year,
        date,
        startDate,
        endDate,
        decade,
        marker,
        radius,
        dateDiff,
      ];
}
