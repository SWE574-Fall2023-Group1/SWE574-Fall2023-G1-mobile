// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoriesResponseModel _$StoriesResponseModelFromJson(
        Map<String, dynamic> json) =>
    StoriesResponseModel(
      stories: (json['stories'] as List<dynamic>?)
          ?.map((e) => StoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasNext: json['hasNext'] as bool?,
      hasPrev: json['hasPrev'] as bool?,
      nextPage: json['nextPage'],
      prevPage: json['prevPage'],
      totalPages: json['totalPages'] as int?,
    );

Map<String, dynamic> _$StoriesResponseModelToJson(
        StoriesResponseModel instance) =>
    <String, dynamic>{
      'stories': instance.stories,
      'hasNext': instance.hasNext,
      'hasPrev': instance.hasPrev,
      'nextPage': instance.nextPage,
      'prevPage': instance.prevPage,
      'totalPages': instance.totalPages,
    };
