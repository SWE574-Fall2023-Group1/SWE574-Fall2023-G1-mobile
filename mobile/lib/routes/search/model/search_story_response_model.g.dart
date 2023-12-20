// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_story_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchStoryResponseModel _$SearchStoryResponseModelFromJson(
        Map<String, dynamic> json) =>
    SearchStoryResponseModel(
      stories: (json['stories'] as List<dynamic>?)
          ?.map((e) => StoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchStoryResponseModelToJson(
        SearchStoryResponseModel instance) =>
    <String, dynamic>{
      'stories': instance.stories,
    };
