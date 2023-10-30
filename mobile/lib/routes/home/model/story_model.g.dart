// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryModel _$StoryModelFromJson(Map<String, dynamic> json) => StoryModel(
      id: json['id'] as int,
      author: json['author'] as int,
      author_username: json['author_username'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      story_tags: json['story_tags'] as String,
      location_ids: (json['location_ids'] as List<dynamic>)
          .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      date_type: json['date_type'] as String,
      season_name: json['season_name'] as String?,
      year: json['year'] as int?,
      start_year: json['start_year'] as int?,
      end_year: json['end_year'] as int?,
      date: json['date'] as String?,
      creation_date: DateTime.parse(json['creation_date'] as String),
      start_date: json['start_date'] as String?,
      end_date: json['end_date'] as String?,
      decade: json['decade'] as int?,
      include_time: json['include_time'] as bool,
      likes: (json['likes'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$StoryModelToJson(StoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'author_username': instance.author_username,
      'title': instance.title,
      'content': instance.content,
      'story_tags': instance.story_tags,
      'location_ids': instance.location_ids,
      'date_type': instance.date_type,
      'season_name': instance.season_name,
      'year': instance.year,
      'start_year': instance.start_year,
      'end_year': instance.end_year,
      'date': instance.date,
      'creation_date': instance.creation_date.toIso8601String(),
      'start_date': instance.start_date,
      'end_date': instance.end_date,
      'decade': instance.decade,
      'include_time': instance.include_time,
      'likes': instance.likes,
    };
