// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      success: json['success'] as bool,
      msg: json['msg'] as String?,
      point: json['point'] as String?,
      line: json['line'] as String?,
      polygon: json['polygon'] as String?,
      circle: json['circle'] as String?,
      radius: json['radius'] as String?,
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'point': instance.point,
      'line': instance.line,
      'polygon': instance.polygon,
      'circle': instance.circle,
      'radius': instance.radius,
      'success': instance.success,
      'msg': instance.msg,
    };
