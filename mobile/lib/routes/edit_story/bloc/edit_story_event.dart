part of 'edit_story_bloc.dart';

sealed class EditStoryEvent extends Equatable {
  const EditStoryEvent();
}

class EditStoryUpdateStoryEvent extends EditStoryEvent {
  final int id;
  final String title;
  final String content;
  final List<TagModel> storyTags;
  final String dateType;
  final List<Marker>? markersForPoint;
  final List<Polygon>? polygons;
  final List<Polyline>? polyLines;
  final List<CircleMarker>? circleMarkers;
  final List<String>? pointAdresses;
  final List<String>? circleAdresses;
  final List<String>? polylineAdresses;
  final String? seasonName;
  final String? startYear;
  final String? endYear;
  final String? year;
  final String? date;
  final String? startDate;
  final String? endDate;
  final String? decade;
  final bool includeTime;

  const EditStoryUpdateStoryEvent({
    required this.id,
    required this.title,
    required this.content,
    required this.storyTags,
    required this.dateType,
    this.markersForPoint,
    this.polygons,
    this.polyLines,
    this.circleMarkers,
    this.pointAdresses,
    this.circleAdresses,
    this.polylineAdresses,
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
        id,
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

class EditStoryErrorPopupClosedEvent extends EditStoryEvent {
  @override
  List<Object?> get props => <Object?>[];
}
