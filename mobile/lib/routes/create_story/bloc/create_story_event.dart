part of 'create_story_bloc.dart';

sealed class CreateStoryEvent extends Equatable {
  const CreateStoryEvent();
}

class CreateStoryCreateStoryEvent extends CreateStoryEvent {
  final String title;
  final String content;
  final String storyTags;
  final String dateType;
  final List<Marker>? markersForPoint;
  final List<Polygon>? polygons;
  final List<Polyline>? polyLines;
  final List<CircleMarker>? circleMarkers;
  final String? seasonName;
  final String? startYear;
  final String? endYear;
  final String? year;
  final String? date;
  final String? startDate;
  final String? endDate;
  final String? decade;
  final bool includeTime;

  const CreateStoryCreateStoryEvent({
    required this.title,
    required this.content,
    required this.storyTags,
    required this.dateType,
    this.markersForPoint,
    this.polygons,
    this.polyLines,
    this.circleMarkers,
    this.seasonName,
    this.startYear,
    this.endYear,
    this.year,
    this.date,
    this.startDate,
    this.endDate,
    this.decade,
    this.includeTime = false,
  });

  @override
  List<Object?> get props => <Object?>[
        title,
        content,
        storyTags,
        dateType,
        markersForPoint,
        polygons,
        polyLines,
        circleMarkers,
        seasonName,
        startYear,
        endYear,
        year,
        date,
        startDate,
        endDate,
        decade,
        includeTime,
      ];
}

class CreateStoryErrorPopupClosedEvent extends CreateStoryEvent {
  @override
  List<Object?> get props => <Object?>[];
}
