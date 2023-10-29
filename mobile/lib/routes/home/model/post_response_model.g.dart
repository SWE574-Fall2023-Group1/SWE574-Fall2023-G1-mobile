// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
      username: json['username'] as String,
      title: json['title'] as String,
      date: json['date'] as String,
      location: json['location'] as String,
    );

Map<String, dynamic> _$PostModelToJson(PostModel instance) => <String, dynamic>{
      'username': instance.username,
      'title': instance.title,
      'date': instance.date,
      'location': instance.location,
    };
