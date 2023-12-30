import 'package:json_annotation/json_annotation.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';
import 'package:memories_app/routes/home/model/location_model.dart';

part 'story_model.g.dart';

@JsonSerializable()
class StoryModel {
  int id;
  int? author;
  @JsonKey(name: "author_username")
  String? authorUsername;
  String? title;
  String? content;
  @JsonKey(name: "story_tags")
  List<TagModel>? storyTags;
  @JsonKey(name: "location_ids")
  List<LocationModel>? locations;
  @JsonKey(name: "date_type")
  String? dateType;
  @JsonKey(name: "season_name")
  String? seasonName;
  int? year;
  @JsonKey(name: "start_year")
  int? startYear;
  @JsonKey(name: "end_year")
  int? endYear;
  String? date;
  @JsonKey(name: "creation_date")
  DateTime? creationDate;
  @JsonKey(name: "start_date")
  String? startDate;
  @JsonKey(name: "end_date")
  String? endDate;
  int? decade;
  @JsonKey(name: "include_time")
  bool includeTime;
  List<int>? likes;
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? dateText;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isEditable = false;

  StoryModel({
    required this.id,
    required this.author,
    required this.authorUsername,
    required this.title,
    required this.content,
    required this.storyTags,
    required this.locations,
    required this.dateType,
    required this.seasonName,
    required this.year,
    required this.startYear,
    required this.endYear,
    required this.date,
    required this.creationDate,
    required this.startDate,
    required this.endDate,
    required this.decade,
    required this.includeTime,
    required this.likes,
    this.dateText,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryModelToJson(this);
}
