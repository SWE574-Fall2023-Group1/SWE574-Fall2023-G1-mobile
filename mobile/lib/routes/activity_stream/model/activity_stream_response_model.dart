import 'package:json_annotation/json_annotation.dart';
import 'package:memories_app/network/model/response_model.dart';

part 'activity_stream_response_model.g.dart';

@JsonSerializable()
class ActivityStreamResponseModel extends ResponseModel {
  List<Activity> activity;

  ActivityStreamResponseModel({
    required bool? success,
    required String? msg,
    required this.activity,
  }) : super(success, msg);

  factory ActivityStreamResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityStreamResponseModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ActivityStreamResponseModelToJson(this);
}

@JsonSerializable()
class Activity {
  int id;
  int user;
  @JsonKey(name: "user_username")
  String userUsername;
  @JsonKey(name: "activity_type")
  String activityType;
  DateTime date;
  bool viewed;
  @JsonKey(name: "target_user")
  int targetUser;
  @JsonKey(name: "target_user_username")
  String targetUserUsername;
  @JsonKey(name: "target_story")
  int? targetStory;
  @JsonKey(name: "target_story_title")
  String? targetStoryTitle;

  Activity({
    required this.id,
    required this.user,
    required this.userUsername,
    required this.activityType,
    required this.date,
    required this.viewed,
    required this.targetUser,
    required this.targetUserUsername,
    required this.targetStory,
    required this.targetStoryTitle,
  });

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);

}
