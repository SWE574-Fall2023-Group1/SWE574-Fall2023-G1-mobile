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
    );

Map<String, dynamic> _$RecommendationToJson(Recommendation instance) =>
    <String, dynamic>{
      'story': instance.story,
    };
