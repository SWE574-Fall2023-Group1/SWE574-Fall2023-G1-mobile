// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendations_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendationsResponseModel _$RecommendationsResponseModelFromJson(
        Map<String, dynamic> json) =>
    RecommendationsResponseModel(
      success: json['success'] as bool?,
      msg: json['msg'] as String?,
      recommendations: (json['recommendations'] as List<dynamic>?)
          ?.map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RecommendationsResponseModelToJson(
        RecommendationsResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'recommendations': instance.recommendations,
    };

Recommendation _$RecommendationFromJson(Map<String, dynamic> json) =>
    Recommendation(
      story: json['story'] == null
          ? null
          : StoryModel.fromJson(json['story'] as Map<String, dynamic>),
      user: json['user'] as int,
      relatedStories: (json['related_stories'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      locationRelated: json['location_related'] as bool,
      timeRelated: json['time_related'] as bool,
      contentRelated: json['content_related'] as int,
      tagRelated: json['tag_related'] as bool,
      showCount: json['show_count'] as int,
      hasBeenShown: json['has_been_shown'] as bool,
      points: json['points'] as int,
    );

Map<String, dynamic> _$RecommendationToJson(Recommendation instance) =>
    <String, dynamic>{
      'story': instance.story,
      'user': instance.user,
      'related_stories': instance.relatedStories,
      'location_related': instance.locationRelated,
      'time_related': instance.timeRelated,
      'content_related': instance.contentRelated,
      'tag_related': instance.tagRelated,
      'show_count': instance.showCount,
      'has_been_shown': instance.hasBeenShown,
      'points': instance.points,
    };
