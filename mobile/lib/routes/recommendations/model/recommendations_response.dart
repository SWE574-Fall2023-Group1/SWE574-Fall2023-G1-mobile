import 'package:json_annotation/json_annotation.dart';
import 'package:memories_app/network/model/response_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';

part 'recommendations_response.g.dart';

@JsonSerializable()
class RecommendationsResponseModel extends ResponseModel {
  List<Recommendation>? recommendations;

  RecommendationsResponseModel({
    required bool? success,
    required String? msg,
    required this.recommendations,
  }) : super(success, msg);

  factory RecommendationsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsResponseModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RecommendationsResponseModelToJson(this);
}

@JsonSerializable()
class Recommendation {
  StoryModel? story;
  int user;
  @JsonKey(name: 'related_stories')
  List<int> relatedStories;
  @JsonKey(name: 'location_related')
  bool locationRelated;
  @JsonKey(name: 'time_related')
  bool timeRelated;
  @JsonKey(name: 'content_related')
  int contentRelated;
  @JsonKey(name: 'tag_related')
  bool tagRelated;
  @JsonKey(name: 'show_count')
  int showCount;
  @JsonKey(name: 'has_been_shown')
  bool hasBeenShown;
  int points;

  Recommendation({
    required this.story,
    required this.user,
    required this.relatedStories,
    required this.locationRelated,
    required this.timeRelated,
    required this.contentRelated,
    required this.tagRelated,
    required this.showCount,
    required this.hasBeenShown,
    required this.points,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) =>
      _$RecommendationFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RecommendationToJson(this);
}
