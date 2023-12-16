import 'package:json_annotation/json_annotation.dart';

part 'search_story_request_model.g.dart';

@JsonSerializable()
class SearchStoryRequestModel {
  String? title;
  String? author;
  String? tag;
  @JsonKey(name: "tag_label", includeIfNull: false)
  String? tagLabel;
  @JsonKey(name: "time_type")
  String? timeType;
  @JsonKey(name: "time_value")
  TimeValue? timeValue;
  Location? location;
  @JsonKey(name: "radius_diff")
  int radiusDiff;
  @JsonKey(name: "date_diff", includeIfNull: false)
  int? dateDiff;
  @JsonKey(name: "sort_field")
  String? sortField;

  SearchStoryRequestModel({
    required this.title,
    required this.author,
    required this.tag,
    required this.tagLabel,
    required this.timeType,
    required this.timeValue,
    required this.location,
    required this.radiusDiff,
    required this.dateDiff,
    this.sortField = "extract_timestamp",
  });

  factory SearchStoryRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SearchStoryRequestModelFromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$SearchStoryRequestModelToJson(this);
    if (location == null) {
      data['location'] = "";
    }
    return data;
  }
}

@JsonSerializable()
class Location {
  String type;
  List<double> coordinates;

  Location({required this.coordinates, required this.type});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

abstract class TimeValue {
  factory TimeValue.fromJson(Map<String, dynamic> json) {
    final String type = json['time_type'] as String;
    switch (type) {
      case 'normal_year':
        return NormalYear.fromJson(json);
      case 'interval_year':
        return IntervalYear.fromJson(json);
      case 'interval_date':
        return IntervalDate.fromJson(json);
      case 'normal_date':
        return NormalDate.fromJson(json);
      case 'decade':
        return Decade.fromJson(json);
      default:
        throw UnsupportedError('Unsupported time value type: $type');
    }
  }

  Map<String, dynamic> toJson();
}

@JsonSerializable()
class NormalYear implements TimeValue {
  String year;
  @JsonKey(name: "season_name")
  String seasonName;

  NormalYear({
    required this.year,
    this.seasonName = '',
  });

  factory NormalYear.fromJson(Map<String, dynamic> json) =>
      _$NormalYearFromJson(json);

  Map<String, dynamic> toJson() => _$NormalYearToJson(this);
}

@JsonSerializable()
class IntervalYear implements TimeValue {
  String startYear;
  String endYear;
  @JsonKey(name: "season_name")
  String seasonName;

  IntervalYear({
    required this.startYear,
    required this.endYear,
    this.seasonName = '',
  });

  factory IntervalYear.fromJson(Map<String, dynamic> json) =>
      _$IntervalYearFromJson(json);

  Map<String, dynamic> toJson() => _$IntervalYearToJson(this);
}

@JsonSerializable()
class IntervalDate implements TimeValue {
  String startDate;
  String endDate;

  IntervalDate({
    required this.startDate,
    required this.endDate,
  });

  factory IntervalDate.fromJson(Map<String, dynamic> json) =>
      _$IntervalDateFromJson(json);

  Map<String, dynamic> toJson() => _$IntervalDateToJson(this);
}

@JsonSerializable()
class NormalDate implements TimeValue {
  String date;

  NormalDate({
    required this.date,
  });

  factory NormalDate.fromJson(Map<String, dynamic> json) =>
      _$NormalDateFromJson(json);

  Map<String, dynamic> toJson() => _$NormalDateToJson(this);
}

@JsonSerializable()
class Decade implements TimeValue {
  int decade;

  Decade({
    required this.decade,
  });

  factory Decade.fromJson(Map<String, dynamic> json) => _$DecadeFromJson(json);

  Map<String, dynamic> toJson() => _$DecadeToJson(this);
}
