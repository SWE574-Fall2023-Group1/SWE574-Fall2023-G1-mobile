// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: always_specify_types

part of 'create_story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateStoryModel _$CreateStoryModelFromJson(Map<String, dynamic> json) =>
    CreateStoryModel(
      title: json['title'] as String,
      content: json['content'] as String,
      storyTags: json['storyTags'] as String,
      locationIds: (json['locationIds'] as List<dynamic>)
          .map((e) => LocationId.fromJson(e as Map<String, dynamic>))
          .toList(),
      dateType: json['dateType'] as String,
      seasonName: json['seasonName'] as String?,
      startYear: json['startYear'] as String?,
      endYear: json['endYear'] as String?,
      year: json['year'] as String?,
      date: json['date'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      decade: json['decade'] as String?,
      includeTime: json['includeTime'] as bool? ?? false,
    );

Map<String, dynamic> _$CreateStoryModelToJson(CreateStoryModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'storyTags': instance.storyTags,
      'locationIds': instance.locationIds,
      'dateType': instance.dateType,
      'seasonName': instance.seasonName,
      'startYear': instance.startYear,
      'endYear': instance.endYear,
      'year': instance.year,
      'date': instance.date,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'decade': instance.decade,
      'includeTime': instance.includeTime,
    };

LocationId _$LocationIdFromJson(Map<String, dynamic> json) => LocationId(
      name: json['name'] as String,
      point: json['point'] == null
          ? null
          : Point.fromJson(json['point'] as Map<String, dynamic>),
      circle: json['circle'] == null
          ? null
          : Point.fromJson(json['circle'] as Map<String, dynamic>),
      radius: (json['radius'] as num?)?.toDouble(),
      polygon: json['polygon'] == null
          ? null
          : Polygon.fromJson(json['polygon'] as Map<String, dynamic>),
      line: json['line'] == null
          ? null
          : LineString.fromJson(json['line'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationIdToJson(LocationId instance) =>
    <String, dynamic>{
      'name': instance.name,
      'point': instance.point,
      'circle': instance.circle,
      'radius': instance.radius,
      'polygon': instance.polygon,
      'line': instance.line,
    };

Point _$PointFromJson(Map<String, dynamic> json) => Point(
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      type: json['type'] as String? ?? "Point",
    );

Map<String, dynamic> _$PointToJson(Point instance) => <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

Polygon _$PolygonFromJson(Map<String, dynamic> json) => Polygon(
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => (e as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList())
              .toList())
          .toList(),
      type: json['type'] as String? ?? "Polygon",
    );

Map<String, dynamic> _$PolygonToJson(Polygon instance) => <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

LineString _$LineStringFromJson(Map<String, dynamic> json) => LineString(
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
      type: json['type'] as String? ?? "LineString",
    );

Map<String, dynamic> _$LineStringToJson(LineString instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
