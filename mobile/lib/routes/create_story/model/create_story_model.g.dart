// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateStoryModel _$CreateStoryModelFromJson(Map<String, dynamic> json) =>
    CreateStoryModel(
      title: json['title'] as String,
      content: json['content'] as String,
      storyTags: (json['story_tags'] as List<dynamic>?)
          ?.map((e) => StoryTag.fromJson(e as Map<String, dynamic>))
          .toList(),
      locationIds: (json['location_ids'] as List<dynamic>)
          .map((e) => LocationId.fromJson(e as Map<String, dynamic>))
          .toList(),
      dateType: json['date_type'] as String,
      seasonName: json['season_name'] as String?,
      startYear: json['start_year'] as String?,
      endYear: json['end_year'] as String?,
      year: json['year'] as String?,
      date: json['date'] as String?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      decade: json['decade'] as String?,
      includeTime: json['include_time'] as bool? ?? false,
    );

Map<String, dynamic> _$CreateStoryModelToJson(CreateStoryModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'story_tags': instance.storyTags,
      'location_ids': instance.locationIds,
      'date_type': instance.dateType,
      'season_name': instance.seasonName,
      'start_year': instance.startYear,
      'end_year': instance.endYear,
      'year': instance.year,
      'date': instance.date,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'decade': instance.decade,
      'include_time': instance.includeTime,
    };

StoryTag _$StoryTagFromJson(Map<String, dynamic> json) => StoryTag(
      name: json['name'] as String,
      label: json['label'] as String,
      wikidataId: json['wikidata_id'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$StoryTagToJson(StoryTag instance) => <String, dynamic>{
      'name': instance.name,
      'label': instance.label,
      'wikidata_id': instance.wikidataId,
      'description': instance.description,
    };

LocationId _$LocationIdFromJson(Map<String, dynamic> json) => LocationId(
      name: json['name'] as String,
      point: json['point'] == null
          ? null
          : PointLocation.fromJson(json['point'] as Map<String, dynamic>),
      circle: json['circle'] == null
          ? null
          : PointLocation.fromJson(json['circle'] as Map<String, dynamic>),
      radius: (json['radius'] as num?)?.toDouble(),
      polygon: json['polygon'] == null
          ? null
          : PolygonLocation.fromJson(json['polygon'] as Map<String, dynamic>),
      line: json['line'] == null
          ? null
          : LineStringLocation.fromJson(json['line'] as Map<String, dynamic>),
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

PointLocation _$PointLocationFromJson(Map<String, dynamic> json) =>
    PointLocation(
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      type: json['type'] as String? ?? "Point",
    );

Map<String, dynamic> _$PointLocationToJson(PointLocation instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

PolygonLocation _$PolygonLocationFromJson(Map<String, dynamic> json) =>
    PolygonLocation(
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => (e as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList())
              .toList())
          .toList(),
      type: json['type'] as String? ?? "Polygon",
    );

Map<String, dynamic> _$PolygonLocationToJson(PolygonLocation instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

LineStringLocation _$LineStringLocationFromJson(Map<String, dynamic> json) =>
    LineStringLocation(
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
      type: json['type'] as String? ?? "LineString",
    );

Map<String, dynamic> _$LineStringLocationToJson(LineStringLocation instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
