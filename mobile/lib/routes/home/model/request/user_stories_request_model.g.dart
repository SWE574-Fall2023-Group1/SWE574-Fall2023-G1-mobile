// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stories_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStoriesRequestModel _$UserStoriesRequestModelFromJson(
        Map<String, dynamic> json) =>
    UserStoriesRequestModel(
      page: json['page'] as int,
      size: json['size'] as int,
    );

Map<String, dynamic> _$UserStoriesRequestModelToJson(
        UserStoriesRequestModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
    };
