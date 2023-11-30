// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) => StoryModel(
      id: json['id'] as int,
      author: json['author'] as int,
      authorUsername: json['author_username'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      storyTags: (json['story_tags'] as List<dynamic>)
          .map((dynamic e) => TagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      locationIds: (json['location_ids'] as List<dynamic>)
          .map((dynamic e) => LocationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      dateType: json['date_type'] as String,
      seasonName: json['season_name'] as String?,
      year: json['year'] as int?,
      startYear: json['start_year'] as int?,
      endYear: json['end_year'] as int?,
      date: json['date'] as String?,
      creationDate: DateTime.parse(json['creation_date'] as String),
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      decade: json['decade'] as int?,
      includeTime: json['include_time'] as bool,
      likes: (json['likes'] as List<dynamic>)
          .map((dynamic e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$StoryModelToJson(StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'author_username': instance.authorUsername,
      'title': instance.title,
      'content': instance.content,
      'story_tags': instance.storyTags,
      'location_ids': instance.locationIds,
      'date_type': instance.dateType,
      'season_name': instance.seasonName,
      'year': instance.year,
      'start_year': instance.startYear,
      'end_year': instance.endYear,
      'date': instance.date,
      'creation_date': instance.creationDate?.toIso8601String(),
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'decade': instance.decade,
      'include_time': instance.includeTime,
      'likes': instance.likes,
    };
