// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_story_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateStoryResponseModel _$CreateStoryResponseModelFromJson(
        Map<String, dynamic> json) =>
    CreateStoryResponseModel(
      success: json['success'] as bool?,
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$CreateStoryResponseModelToJson(
        CreateStoryResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
    };
