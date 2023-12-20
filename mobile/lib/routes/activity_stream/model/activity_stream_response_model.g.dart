// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_stream_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityStreamResponseModel _$ActivityStreamResponseModelFromJson(
        Map<String, dynamic> json) =>
    ActivityStreamResponseModel(
      success: json['success'] as bool?,
      msg: json['msg'] as String?,
      activity: (json['activity'] as List<dynamic>)
          .map((e) => Activity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActivityStreamResponseModelToJson(
        ActivityStreamResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'msg': instance.msg,
      'activity': instance.activity,
    };

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['id'] as int,
      user: json['user'] as int,
      userUsername: json['user_username'] as String,
      activityType: json['activity_type'] as String,
      date: DateTime.parse(json['date'] as String),
      viewed: json['viewed'] as bool,
      targetUser: json['target_user'] as int,
      targetUserUsername: json['target_user_username'] as String,
      targetStory: json['target_story'] as int?,
      targetStoryTitle: json['target_story_title'] as String?,
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'user_username': instance.userUsername,
      'activity_type': instance.activityType,
      'date': instance.date.toIso8601String(),
      'viewed': instance.viewed,
      'target_user': instance.targetUser,
      'target_user_username': instance.targetUserUsername,
      'target_story': instance.targetStory,
      'target_story_title': instance.targetStoryTitle,
    };
