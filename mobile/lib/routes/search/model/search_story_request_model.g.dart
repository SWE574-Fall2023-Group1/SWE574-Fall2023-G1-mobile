// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_story_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchStoryRequestModel _$SearchStoryRequestModelFromJson(
        Map<String, dynamic> json) =>
    SearchStoryRequestModel(
      title: json['title'] as String?,
      author: json['author'] as String?,
      tag: json['tag'] as String?,
      tagLabel: json['tag_label'] as String?,
      timeType: json['time_type'] as String?,
      timeValue: json['time_value'] == null
          ? null
          : TimeValue.fromJson(json['time_value'] as Map<String, dynamic>),
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      radiusDiff: json['radius_diff'] as int,
      dateDiff: json['date_diff'] as int?,
      sortField: json['sort_field'] as String? ?? "extract_timestamp",
    );

Map<String, dynamic> _$SearchStoryRequestModelToJson(
    SearchStoryRequestModel instance) {
  final val = <String, dynamic>{
    'title': instance.title,
    'author': instance.author,
    'tag': instance.tag,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tag_label', instance.tagLabel);
  val['time_type'] = instance.timeType;
  val['time_value'] = instance.timeValue;
  val['location'] = instance.location;
  val['radius_diff'] = instance.radiusDiff;
  writeNotNull('date_diff', instance.dateDiff);
  val['sort_field'] = instance.sortField;
  return val;
}

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };

NormalYear _$NormalYearFromJson(Map<String, dynamic> json) => NormalYear(
      year: json['year'] as String,
      seasonName: json['seasonName'] as String? ?? '',
    );

Map<String, dynamic> _$NormalYearToJson(NormalYear instance) =>
    <String, dynamic>{
      'year': instance.year,
      'seasonName': instance.seasonName,
    };

IntervalYear _$IntervalYearFromJson(Map<String, dynamic> json) => IntervalYear(
      startYear: json['startYear'] as String,
      endYear: json['endYear'] as String,
      seasonName: json['seasonName'] as String? ?? '',
    );

Map<String, dynamic> _$IntervalYearToJson(IntervalYear instance) =>
    <String, dynamic>{
      'startYear': instance.startYear,
      'endYear': instance.endYear,
      'seasonName': instance.seasonName,
    };

IntervalDate _$IntervalDateFromJson(Map<String, dynamic> json) => IntervalDate(
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
    );

Map<String, dynamic> _$IntervalDateToJson(IntervalDate instance) =>
    <String, dynamic>{
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };

NormalDate _$NormalDateFromJson(Map<String, dynamic> json) => NormalDate(
      date: json['date'] as String,
    );

Map<String, dynamic> _$NormalDateToJson(NormalDate instance) =>
    <String, dynamic>{
      'date': instance.date,
    };

Decade _$DecadeFromJson(Map<String, dynamic> json) => Decade(
      decade: json['decade'] as int,
    );

Map<String, dynamic> _$DecadeToJson(Decade instance) => <String, dynamic>{
      'decade': instance.decade,
    };
