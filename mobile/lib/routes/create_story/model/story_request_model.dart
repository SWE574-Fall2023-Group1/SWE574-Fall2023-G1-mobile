import 'package:json_annotation/json_annotation.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';

part 'story_request_model.g.dart';

@JsonSerializable()
class StoryRequestModel {
  final String title;
  final String content;
  @JsonKey(name: 'story_tags')
  final List<TagModel>? storyTags;
  @JsonKey(name: 'location_ids')
  final List<LocationId> locationIds;
  @JsonKey(name: 'date_type')
  final String dateType;
  @JsonKey(name: 'season_name')
  final String? seasonName;
  @JsonKey(name: 'start_year')
  final String? startYear;
  @JsonKey(name: 'end_year')
  final String? endYear;
  final String? year;
  final String? date;
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  final int? decade;
  @JsonKey(name: 'include_time')
  bool includeTime;

  StoryRequestModel({
    required this.title,
    required this.content,
    required this.storyTags,
    required this.locationIds,
    required this.dateType,
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

  factory StoryRequestModel.fromJson(Map<String, dynamic> json) =>
      _$StoryRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryRequestModelToJson(this);
}

@JsonSerializable()
class LocationId {
  final String name;
  @JsonKey(includeIfNull: false)
  final PointLocation? point;
  @JsonKey(includeIfNull: false)
  final PointLocation? circle;
  @JsonKey(includeIfNull: false)
  final double? radius;
  @JsonKey(includeIfNull: false)
  final PolygonLocation? polygon;
  @JsonKey(includeIfNull: false)
  final LineStringLocation? line;

  LocationId({
    required this.name,
    this.point,
    this.circle,
    this.radius,
    this.polygon,
    this.line,
  });

  factory LocationId.fromJson(Map<String, dynamic> json) =>
      _$LocationIdFromJson(json);

  Map<String, dynamic> toJson() => _$LocationIdToJson(this);
}

@JsonSerializable()
class PointLocation {
  final String? type;
  final List<double> coordinates;

  PointLocation({
    required this.coordinates,
    this.type = "Point",
  });

  factory PointLocation.fromJson(Map<String, dynamic> json) =>
      _$PointLocationFromJson(json);

  Map<String, dynamic> toJson() => _$PointLocationToJson(this);
}

@JsonSerializable()
class PolygonLocation {
  final String? type;
  final List<List<List<double>>> coordinates;

  PolygonLocation({
    required this.coordinates,
    this.type = "Polygon",
  });

  factory PolygonLocation.fromJson(Map<String, dynamic> json) =>
      _$PolygonLocationFromJson(json);

  Map<String, dynamic> toJson() => _$PolygonLocationToJson(this);
}

@JsonSerializable()
class LineStringLocation {
  final String? type;
  final List<List<double>> coordinates;

  LineStringLocation({
    required this.coordinates,
    this.type = "LineString",
  });

  factory LineStringLocation.fromJson(Map<String, dynamic> json) =>
      _$LineStringLocationFromJson(json);

  Map<String, dynamic> toJson() => _$LineStringLocationToJson(this);
}
