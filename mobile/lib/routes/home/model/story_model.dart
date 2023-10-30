import 'package:memories_app/routes/home/model/location_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel {
  int id;
  int author;
  String author_username;
  String title;
  String content;
  String story_tags;
  List<LocationModel> location_ids;
  String date_type;
  String? season_name;
  int? year;
  int? start_year;
  int? end_year;
  String? date;
  DateTime creation_date;
  String? start_date;
  String? end_date;
  int? decade;
  bool include_time;
  List<int> likes;

  StoryModel({
    required this.id,
    required this.author,
    required this.author_username,
    required this.title,
    required this.content,
    required this.story_tags,
    required this.location_ids,
    required this.date_type,
    required this.season_name,
    required this.year,
    required this.start_year,
    required this.end_year,
    required this.date,
    required this.creation_date,
    required this.start_date,
    required this.end_date,
    required this.decade,
    required this.include_time,
    required this.likes,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryModelToJson(this);
}
