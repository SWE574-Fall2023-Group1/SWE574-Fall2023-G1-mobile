// ignore_for_file: always_specify_types

import 'package:json_annotation/json_annotation.dart';

part 'create_story_model.g.dart';

@JsonSerializable()
class CreateStoryModel {
  final String title;
  final String content;
  final String storyTags;
  final List<LocationId> locationIds;

  final String dateType;
  final String? seasonName;
  final String? startYear;
  final String? endYear;
  final String? year;
  final String? date;
  final String? startDate;
  final String? endDate;
  final String? decade;
  bool includeTime;

  CreateStoryModel({
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

  factory CreateStoryModel.fromJson(Map<String, dynamic> json) =>
      _$CreateStoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateStoryModelToJson(this);
}

@JsonSerializable()
class LocationId {
  String name;
  Point? point;
  Point? circle;
  double? radius;
  Polygon? polygon;
  LineString? line;

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
class Point {
  final String? type;
  List<double> coordinates;

  Point({
    required this.coordinates,
    this.type = "Point",
  });

  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);

  Map<String, dynamic> toJson() => _$PointToJson(this);
}

@JsonSerializable()
class Polygon {
  final String? type;
  final List<List<List<double>>> coordinates;

  Polygon({
    required this.coordinates,
    this.type = "Polygon",
  });

  factory Polygon.fromJson(Map<String, dynamic> json) =>
      _$PolygonFromJson(json);

  Map<String, dynamic> toJson() => _$PolygonToJson(this);
}

@JsonSerializable()
class LineString {
  final String? type;
  List<List<double>> coordinates;

  LineString({
    required this.coordinates,
    this.type = "LineString",
  });

  factory LineString.fromJson(Map<String, dynamic> json) =>
      _$LineStringFromJson(json);

  Map<String, dynamic> toJson() => _$LineStringToJson(this);
}
